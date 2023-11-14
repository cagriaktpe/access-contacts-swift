//
//  ContentView.swift
//  access-contacts
//
//  Created by Samet Çağrı Aktepe on 14.11.2023.
//

import SwiftUI
import Contacts

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            Task {
                await fetchSpecificContacts()
            }
        }
    }
    
    func fetchSpecificContacts() async {
        // run this in the background async
        
        // get access to the contacts store
        let store = CNContactStore()
        
        // specify which data keys we want to fetch
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        
        // search criteria
        let predicate = CNContact.predicateForContacts(matchingName: "Kate")
        
        // call method to fetch all contacts
        do {
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
            
            print(contacts)
        } catch {
            print("Error fetching contacts")
        }
        
    }
    
    func fetchAllContacts() async {
        // run this in the background async
        
        // get access to the contacts store
        let store = CNContactStore()
        
        // specify which data keys we want to fetch
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        
        // create fetch request
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        // call method to fetch all contacts
        do {
            try store.enumerateContacts(with: request) { (contact, result) in
                // print the contact
                print(contact.givenName)
                
                for number in contact.phoneNumbers {
                    switch number.label {
                        case CNLabelPhoneNumberMobile:
                            print("Mobile: \(number.value.stringValue)")
                        case CNLabelPhoneNumberiPhone:
                            print("iPhone: \(number.value.stringValue)")
                        case CNLabelPhoneNumberMain:
                            print("Main: \(number.value.stringValue)")
                    default:
                        print("Other: \(number.value.stringValue)")
                    }
                }
            }
        } catch {
            print("Error fetching contacts")
        }
    }
        
}

#Preview {
    ContentView()
}
