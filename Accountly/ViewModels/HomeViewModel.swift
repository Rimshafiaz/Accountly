import Foundation
import FirebaseDatabase
import Combine

class HomeViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let databaseRef = Database.database().reference()
    private let useMockData = false
    
    func fetchAllUsers() {
        if useMockData {
            loadMockData()
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        databaseRef.child("users").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                guard snapshot.exists() else {
                    self.errorMessage = "No users found"
                    return
                }
                
                var fetchedUsers: [User] = []
                
                for child in snapshot.children {
                    guard let snapshot = child as? DataSnapshot,
                          let userData = snapshot.value as? [String: Any] else {
                        continue
                    }
                    
                    let user = User(
                        id: snapshot.key,
                        firstName: userData["firstName"] as? String ?? "",
                        lastName: userData["lastName"] as? String ?? "",
                        contactNumber: userData["contactNumber"] as? String ?? "",
                        birthDay: userData["birthDay"] as? String ?? "",
                        birthMonth: userData["birthMonth"] as? String ?? "",
                        birthYear: userData["birthYear"] as? String ?? "",
                        email: userData["email"] as? String ?? "",
                        profileImageURL: userData["profileImageURL"] as? String
                    )
                    
                    fetchedUsers.append(user)
                }
                
                self.users = fetchedUsers
            }
        }
    }
    
    private func loadMockData() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() ) { [weak self] in
            self?.users = [
                User(
                    id: "1",
                    firstName: "Ahmed",
                    lastName: "Khan",
                    contactNumber: "0300-1234567",
                    birthDay: "15",
                    birthMonth: "03",
                    birthYear: "1998",
                    email: "ahmed.khan@example.com",
                    profileImageURL: nil
                ),
                User(
                    id: "2",
                    firstName: "Fatima",
                    lastName: "Ali",
                    contactNumber: "0321-9876543",
                    birthDay: "22",
                    birthMonth: "07",
                    birthYear: "2000",
                    email: "fatima.ali@example.com",
                    profileImageURL: nil
                ),
                User(
                    id: "3",
                    firstName: "Hassan",
                    lastName: "Malik",
                    contactNumber: "0333-5554444",
                    birthDay: "10",
                    birthMonth: "11",
                    birthYear: "1995",
                    email: "hassan.malik@example.com",
                    profileImageURL: nil
                ),
                User(
                    id: "4",
                    firstName: "Ayesha",
                    lastName: "Saeed",
                    contactNumber: "0345-7778888",
                    birthDay: "05",
                    birthMonth: "09",
                    birthYear: "2001",
                    email: "ayesha.saeed@example.com",
                    profileImageURL: nil
                ),
                User(
                    id: "5",
                    firstName: "Bilal",
                    lastName: "Ahmad",
                    contactNumber: "0312-3334444",
                    birthDay: "28",
                    birthMonth: "12",
                    birthYear: "1999",
                    email: "bilal.ahmad@example.com",
                    profileImageURL: nil
                )
            ]
            
            self?.isLoading = false
        }
    }
}
