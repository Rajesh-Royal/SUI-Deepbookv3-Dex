#[test_only]
module dacade_zklogin::notes_tests {
    use dacade_zklogin::notes::{Self, Note};
    use sui::test_scenario;
    use std::string::{Self};

    #[test]
    fun test_create_and_delete_note() {
        let user = @0xA;
        let scenario = test_scenario::begin(user);

        // 1. Create a note
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let title = string::utf8(b"My First Note");
            let body = string::utf8(b"This is the body of my note.");
            notes::create_note(title, body, ctx);
        };

        // 2. Verify note creation and ownership
        test_scenario::next_tx(&mut scenario, user);
        {
            let note = test_scenario::take_from_sender<Note>(&scenario);
            // We can't read fields of Note directly as they are not public, 
            // but taking it from sender proves it exists and is owned by user.
            
            // 3. Delete the note
            let ctx = test_scenario::ctx(&mut scenario);
            notes::delete_note(note, ctx);
        };

        // 4. Verify note deletion
        test_scenario::next_tx(&mut scenario, user);
        {
            // To verify deletion, we check that the user no longer has the note.
            assert!(!test_scenario::has_most_recent_for_sender<Note>(&scenario), 0);
        };

        test_scenario::end(scenario);
    }
}
