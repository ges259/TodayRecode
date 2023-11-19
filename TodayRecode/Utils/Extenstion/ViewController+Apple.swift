//
//  ViewController+Apple.swift
//  TodayRecord
//
//  Created by 계은성 on 2023/11/17.
//

import AuthenticationServices   // 애플 로그인 관련 라이브러리
import CryptoKit                // 해시값 추가
import FirebaseAuth             // 파이어베이스 로그인 관련 라이브러리
import SwiftJWT
import Alamofire

fileprivate var currentNonce: String?
extension SelectALoginMethodController {

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

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
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







// MARK: - 델리게이트 - 필수 메서드
extension SelectALoginMethodController: ASAuthorizationControllerDelegate {
    // ********** 필수 메서드 1 **********
    // 성공 후 동작
    // controller로 인증 정보 값을 받게 되면은, idToken 값을 받음
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization) {



//            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }

            // 처음 로그인 시에만 이메일을 얻을 수 있음
            // 두번째부터는 credential.email은 nil값,
            // credential.identityToken에 들어있음
//            if let email = credential.email {
//                // 이메일 얻기
//            }
//            // 이름
//            if let fullName = credential.fullName {
//            }

            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // nonce : 암호화된 임의의 난수, 단 한번만 사용 가능
                // 동일한 요청을 짧은 시간에 여러번 보내는 릴레이 공격 방지
                // 정보 탈취 없이 안전하게 인증 정보 전달을 위한 안전장치
                guard let nonce = currentNonce,
                      let appleIDToken = appleIDCredential.identityToken,
                      let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    // MARK: - Fix
                    // 얼럿창 띄우기
                    return
                }
                
                // authorization code를 갖고 있는 변수
                // 한번 발급된 authorizationCode는 1번만 사용될 수 있으며 5분간 유효
//                let authorizationCode = appleIDCredential.authorizationCode
                
                        // authorization code
                if  let authorizationCode = appleIDCredential.authorizationCode,
                    let authCodeString = String(data: authorizationCode,
                                                encoding: .utf8),
                        // 토큰
                    let identityToken = appleIDCredential.identityToken,
                    let identifyTokenString = String(data: identityToken,
                                                     encoding: .utf8) {
                    
                    UserDefaults.standard.set(
                        authCodeString,
                        forKey: UserDefault_Apple.authCodeString)
                    
                    print("authCodeString: \(authCodeString)")
                    print("identifyTokenString: \(identifyTokenString)")
                }
                
                
                
                
                
                

                // Initialize a Firebase credential, including the user's full name.
                let credential = OAuthProvider.appleCredential(
                    withIDToken: idTokenString,
                    rawNonce: nonce,
                    fullName: appleIDCredential.fullName)

                // Sign in with Firebase.
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let _ = error  {
                        // MARK: - Fix
                        // 얼럿창 띄우기
                        return
                    }
                    // 성공
                    self.delegate?.authenticationComplete()
                }
            }
        }
}








extension SelectALoginMethodController :
    ASAuthorizationControllerPresentationContextProviding {
    // ********** 필수 메서드 2 **********
    // 실패 후 동작
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
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
    
    
    
    //client_secret
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
        UserDefaults.standard.set(signedJWT, forKey: UserDefault_Apple.client_secret)
        return signedJWT
    }
    
    
    
    
    
    
    // MARK: - 클라이언트_리프레시 토큰
    // client_refreshToken
    // 발급받은 JWT를 포함하여 token을 Generate.
    // UserDefaults를 활용하여 Authorization code와 client_secret을 저장.
    func getAppleRefreshToken(code: String,
                              completionHandler: @escaping (String?) -> Void) {

        guard let secret = UserDefaults.standard.string(forKey: UserDefault_Apple.client_secret) else {return}

        let url = "https://appleid.apple.com/auth/token?client_id=ges.TodayRecord&client_secret=\(secret)&code=\(code)&grant_type=authorization_code"
        
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

                    if decodedData.refresh_token == nil {
                        let dialog = UIAlertController(title: "error", message: "토큰 생성 실패", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "확인", style: .cancel)
                        dialog.addAction(okayAction)
                        self.present(dialog, animated: true, completion: nil)
                    }else{
                        completionHandler(decodedData.refresh_token)
                    }
                }

            case .failure(_):
                //로그아웃 후 재로그인하여
                let dialog = UIAlertController(title: "error", message: "토큰 생성 실패", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "확인", style: .cancel)
                
                
                dialog.addAction(okayAction)
                self.present(dialog, animated: true, completion: nil)
            }
        }
    }
    
    
    
    // MARK: - revokeToken (취소 토큰)
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
