#[lint_allow(self_transfer)]
module dacade_zklogin::notes {
    use sui::tx_context::{TxContext, Self};
    use sui::transfer::Self;
    use sui::object::{Self, UID};
    use std::string::String;

    /// Struct to store the ID of the Notes (Shared Object)
    struct Notes has key {
        id: UID
    }

    /// Struct to represent a Note
    struct Note has key, store {
        id: UID,
        title: String,
        body: String
    }

    /// Module initializer to create the Notes shared object
    #[allow(unused_function)]
    fun init(ctx: &mut TxContext) {
        let notes = Notes{
            id: sui::object::new(ctx),
        };
        // Share the Notes object so it can be accessed by everyone
        transfer::share_object(notes)
    }

    /// Function to create a new note
    /// @param title: The title of the note
    /// @param body: The body of the note
    /// @param ctx: The transaction context
    public fun create_note(title: String, body: String, ctx: &mut TxContext) {
        let note = Note {
            id: object::new(ctx),
            title,
            body
        };
        // Transfer the note to the sender of the transaction
        transfer::transfer(note, tx_context::sender(ctx))
    }

    /// Function to delete a note
    /// @param note: The note object to be deleted
    /// @param _ctx: The transaction context (unused but kept for potential future use or standard signature)
    public fun delete_note(note: Note, _ctx: &mut TxContext) {
        // Unpack the Note struct to access its fields
        let Note {id, title: _, body: _} = note;
        // Delete the object ID, effectively deleting the note
        sui::object::delete(id)
    }
}
