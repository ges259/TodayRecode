//
//  ViewController+Apple.swift
//  TodayRecord
//
//  Created by 계은성 on 2023/11/17.
//

import AuthenticationServices   // 애플 로그인 관련 라이브러리
import CryptoKit                // 해시값 추가
import FirebaseAuth             // 파이어베이스 로그인 관련 라이브러리
import SwiftJWT                 // JWT생성 라이브러리
import Alamofire                // API관련 라이브러리

fileprivate var currentNonce: String?

extension SelectALoginMethodController {

    // MARK: - 로그인 시작
    /// Apple로 로그인을 시작할 메서드 (버튼이 눌리면 호출 됨)
    func startSignInWithAppleFlow() {
        // 난수 생성
        let nonce = randomNonceString()
        // 난수 넣기
        currentNonce = nonce

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        // request 요청을 했을 때 none가 포함되어서 릴레이 공격을 방지
        // 추후 파베에서도 무결성 확인을 할 수 있게끔 함
        // 유저로 부터 알 수 있는 정보들 (이름, 이메일)
        // - request를 통해 알 수 있는 정보는 이메일과 이름으로 한정.
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        // ASAuthorizationController => 애플 로그인 시 밑에서 나오는 뷰
        // 해당 뷰에 띄울 정보 (이름과 이메일)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    // MARK: - 해시값 얻기
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    
    // MARK: - 난수 생성
    private func randomNonceString(length: Int = 32) -> String {

        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
}









// MARK: - 로그인 - 필수 메서드1
extension SelectALoginMethodController :
    ASAuthorizationControllerPresentationContextProviding {
    // ********** 필수 메서드 2 **********
    // 실패 후 동작
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// MARK: - 로그인 - 필수 메서드2
extension SelectALoginMethodController: ASAuthorizationControllerDelegate {
    // ********** 필수 메서드 1 **********
    // code == 로그인 시 얻는 토큰
        // ex) caf895788604a4a81944db255e5220d5b.0.rrtuu.q1nPjxTMfSAbH2Y3aLX7Gw
    // client_secret == jwt 생성
    // token == refresh_token (get~로 얻음)
    // 성공 후 동작
    // controller로 인증 정보 값을 받게 되면은, idToken 값을 받음
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization) {
            
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                
                // ********** 회원 탈퇴 **********
                if UserData.deleteAccount {
                    // 회원 탈퇴 과정이 끝났다고 표시
                    UserData.deleteAccount = false
                    self.reAuth(appleIDCredential: appleIDCredential)
                    return
                }
                
                
                // ********** 로그인 **********
                // 애플 로그인 유저의 고유값 ID (ProviderID)
                let userID = appleIDCredential.user
                
                // 토큰 유효성 검사
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                appleIDProvider.getCredentialState(forUserID: userID) { (credentialState, error) in
                    switch credentialState {
                    case .authorized, .revoked, .notFound:
                        // 해당 ID에 대해 인증이 완료되어있는 상태
                        // 해당 ID의 인증이 취소된 상태
                        // 해당 ID의 인증여부를 알 수 없는 상태(최초 진입 등)
                        DispatchQueue.main.async {
                            self.appleLogin(appleIDCredential: appleIDCredential,
                                            signUp: true)
                        }
                    default: break
                    }
                }
            }
        }
    
    // MARK: - 애플 로그인
    // nonce
        // 1. 암호화된 임의의 난수, 단 한번만 사용 가능
        // 2. 동일한 요청을 짧은 시간에 여러번 보내는 릴레이 공격 방지
        // 3. 정보 탈취 없이 안전하게 인증 정보 전달을 위한 안전장치
    // 토큰
    private func appleLogin(appleIDCredential: ASAuthorizationAppleIDCredential,
                            signUp: Bool = false) {
        guard let nonce = currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            // 로그인 실패
            self.deleteAccount_Alert()
            return
        }
        
        // Initialize a Firebase credential, including the user's full name.
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName)
        
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let _ = error  {
                // 로그인 실패
                self.deleteAccount_Alert()
                return
            }
            // 회원가입이라면
            if signUp {
                // -> 유저데이터 생성
                self.saveAppleUserData(appleIDCredential)
            }
            // 성공 - 화면 이동
            self.delegate?.authenticationComplete()
        }
    }
}




















extension SelectALoginMethodController {
    
    // MARK: - 애플 엑세스 토큰 발급 응답 모델
    struct AppleTokenResponse: Codable {
        var access_token: String?
        var token_type: String?
        var expires_in: Int?
        var refresh_token: String?
        var id_token: String?

        enum CodingKeys: String, CodingKey {
            case refresh_token = "refresh_token"
        }
    }
    
    
    
    
    
    
    // MARK: - client_secret (JWT)
    
    func makeJWT() -> String{
        
        // MARK: - client_secret(JWT) 발급 응답 모델
        struct MyClaims: Claims {
            let iss: String
            let iat: Int
            let exp: Int
            let aud: String
            let sub: String
        }
        
        // sign in with apple key ID
        let myHeader = Header(kid: UserDefault_Apple.apple_Key_ID)
        
        let iat = Int(Date().timeIntervalSince1970)
        let exp = iat + 3600
        // Your_Apple_Team_ID
        let myClaims = MyClaims(iss: UserDefault_Apple.apple_Team_ID,
                                iat: iat,
                                exp: exp,
                                aud: UserDefault_Apple.aud,
                                sub: UserDefault_Apple.bundleID) // Your_App_Bundle_ID

        var myJWT = JWT(header: myHeader, claims: myClaims)

        guard let url = Bundle.main.url(forResource: UserDefault_Apple.keyPath,
                                        withExtension: UserDefault_Apple.p8)
        else { return "" }
        
        let privateKey: Data = try! Data(contentsOf: url, options: .alwaysMapped)

        let jwtSigner = JWTSigner.es256(privateKey: privateKey)
        let signedJWT = try! myJWT.sign(using: jwtSigner)
        return signedJWT
    }
    
    
    
    
    
    
    // MARK: - 클라이언트_리프레시 토큰_API
    // client_refreshToken
    // 발급받은 JWT를 포함하여 token을 Generate.
    // UserDefaults를 활용하여 Authorization code와 client_secret을 저장.
    func getAppleRefreshToken(client_secret: String,
                              code: String,
                              completionHandler: @escaping (String?) -> Void) {
        // url 생성
        let url = "https://appleid.apple.com/auth/token?client_id=ges.TodayRecord&client_secret=\(client_secret)&code=\(code)&grant_type=authorization_code"
        
        // header 설정
        let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        

        AF.request(url,
                   method: .post,
                   encoding: JSONEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<500)
        .responseData { response in
            switch response.result {
            case .success(let output):
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(AppleTokenResponse.self, from: output){
                    // 실패 - 리프레시 토큰이 없다면
                    if decodedData.refresh_token == nil {
                        self.deleteAccount_Alert()
                        
                    // 성공 - 리프레시 토큰이 있다면
                    } else {
                        completionHandler(decodedData.refresh_token)
                    }
                }

            case .failure(_):
                //로그아웃 후 재로그인하여
                self.deleteAccount_Alert()
            }
        }
    }
    
    // MARK: - 토큰 삭제
    private func deleteToken(appleIDCredential: ASAuthorizationAppleIDCredential) {
        
        // authorization code를 갖고 있는 변수
        if  let authorizationCode = appleIDCredential.authorizationCode,
            let authCodeString = String(data: authorizationCode,
                                        encoding: .utf8) {
            
            let jwtString = self.makeJWT()
            
            // 리프레시 토큰 가져오기
            self.getAppleRefreshToken(client_secret: jwtString,
                                      code: authCodeString) { output in
                
                // 토큰이 있다면
                if let refreshToken = output {
                    // revoke token을 가져오기 위한 -> api 통신
                    self.revokeAppleToken(clientSecret: jwtString,
                                          token: refreshToken) {
                        // 회원 탈퇴 성공
                        self.customAlert(alertEnum: .deleteAccountSuccess) { _ in }
                        return
                    }
                    
                // 토큰이 없다면
                }else{
                    // 회원 탈퇴 실패
                    self.deleteAccount_Alert()
                }
            }
        }
    }
    
    // MARK: - 취소 토큰_API
    func revokeAppleToken(clientSecret: String,
                          token: String,
                          completionHandler: @escaping () -> Void) {
        let url = "https://appleid.apple.com/auth/revoke?client_id=\(UserDefault_Apple.bundleID)&client_secret=\(clientSecret)&token=\(token)&token_type_hint=refresh_token"
        
           let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]

           AF.request(url,
                      method: .post,
                      headers: header)
           .validate(statusCode: 200..<600)
           .responseData { response in
               guard let statusCode = response.response?.statusCode else { return }
               if statusCode == 200 {
                   // "애플 토큰 삭제 성공!"
                   completionHandler()
               }
           }
       }
}




















extension SelectALoginMethodController {
    
    // MARK: - 사용자 재인증(- 회원 탈퇴)
    private func reAuth(appleIDCredential: ASAuthorizationAppleIDCredential) {
        let user = Auth.auth().currentUser
        guard let nonce = currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            // 로그인 실패
            self.deleteAccount_Alert()
            return
        }
        
        // Initialize a Firebase credential, including the user's full name.
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName)
        
        user?.reauthenticate(with: credential) { result, error in
            if let _ = error {
                // An error happened.
                self.deleteAccount_Alert()
                return
            }
            // User re-authenticated.
            // 토큰 없애기
            self.deleteToken(appleIDCredential: appleIDCredential)
            // 유저 데이터 삭제 + 회원 탈퇴
            Auth_API.shared.deleteFirebaseAccount { _ in }
        }
    }
    
    // MARK: - 유저 데이터 생성
    private func saveAppleUserData(_ appleIDCredential: ASAuthorizationAppleIDCredential) {
        // 첫 번째 로그인만 이메일 / 이름을 얻을 수 있다.
        // 즉 두 번째 로그인부터는 email에서 걸러짐.
        // 옵셔널 바인딩
        guard let uid = Auth.auth().currentUser?.uid,
              let email = appleIDCredential.email,
              let fullName = appleIDCredential.fullName
        else { return }
        
        // 풀네임 가져오기
        let userName = "\(fullName.familyName ?? "")\(fullName.givenName ?? "")"
        // 저장할 유저 정보 딕셔너리 만들기
        let userDatas = [API_String.userName: userName,
                         API_String.email: email,
                         API_String.loginMethod: LoginMethod.apple.description]
        // 유저 정보 데이터 생성
        Auth_API.shared.saveUserData(uid: uid, userDatas: userDatas) { _ in }
    }

    // MARK: - 계정 삭제 실패 얼럿창
    func deleteAccount_Alert() {
        self.customAlert(alertEnum: .deleteAccountFail) { _ in
            UserData.deleteAccount = false
        }
    }
}
