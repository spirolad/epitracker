import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    // Ton URL de projet Supabase (https://...)
    private let supabaseURL = URL(string: "https://icoyutccmqaopdvpelgl.supabase.co")!
    
    private let supabaseKey = "sb_publishable_p3yFedFnvGT-x13rtYAQkQ_-d60gTzk"
    
    let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
    }
}
 
