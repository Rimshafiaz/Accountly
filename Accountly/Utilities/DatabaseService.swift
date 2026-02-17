//
//  DatabaseService.swift
//  Accountly
//
//  Created by Rimsha on 17/02/2026.
//

import FirebaseDatabase

struct DatabaseService {

    // MARK: - References

    static var usersRef: DatabaseReference {
        return Database.database().reference().child("users")
    }

    static func userRef(for userId: String) -> DatabaseReference {
        return usersRef.child(userId)
    }

    // MARK: - Fetch

    static func fetchUser(
        userId: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        userRef(for: userId).observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any] {
                completion(.success(userData))
            } else {
                completion(.failure(NSError(domain: "Database", code: 404, userInfo: [NSLocalizedDescriptionKey: "User data not found"])))
            }
        }
    }

    // MARK: - Save

    static func saveUser(
        userId: String,
        data: [String: Any],
        completion: ((Bool, Error?) -> Void)? = nil
    ) {
        userRef(for: userId).setValue(data) { error, _ in
            completion?(error == nil, error)
        }
    }

    // MARK: - Update

    static func updateUser(
        userId: String,
        data: [String: Any],
        completion: ((Bool, Error?) -> Void)? = nil
    ) {
        userRef(for: userId).updateChildValues(data) { error, _ in
            completion?(error == nil, error)
        }
    }

    // MARK: - Delete

    static func deleteUser(
        userId: String,
        completion: ((Bool, Error?) -> Void)? = nil
    ) {
        userRef(for: userId).removeValue { error, _ in
            completion?(error == nil, error)
        }
    }
}
