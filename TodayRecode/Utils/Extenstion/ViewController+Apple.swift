//
//  ViewController+Apple.swift
//  TodayRecord
//
//  Created by 계은성 on 2023/11/17.
//

import AuthenticationServices   // 애플 로그인 관련 라이브러리
import CryptoKit                // 해시값 추가
import FirebaseAuth             // 파이어베이스 로그인 관련 라이브러리

fileprivate var currentNonce: String?
extension SelectALoginMethodController {
    func startSignInWithAppleFlow() {
        print(#function)
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        // request 요청을 했을 때 none가 포함되어서 릴레이 공격을 방지
        // 추후 파베에서도 무결성 확인을 할 수 있게끔 함
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
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
        print(#function)
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



extension SelectALoginMethodController: ASAuthorizationControllerDelegate {
    
    // controller로 인증 정보 값을 받게 되면은, idToken 값을 받음
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization) {
            
            print(#function)
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // nonce : 암호화된 임의의 난수, 단 한번만 사용 가능
                // 동일한 요청을 짧은 시간에 여러번 보내는 릴레이 공격 방지
                // 정보 탈취 없이 안전하게 인증 정보 전달을 위한 안전장치
                guard let nonce = currentNonce else {
                    // MARK: - Fix
                    // 얼럿창 띄우기
                    return
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    // MARK: - Fix
                    // 얼럿창 띄우기
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    // MARK: - Fix
                    // 얼럿창 띄우기
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

extension SelectALoginMethodController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
