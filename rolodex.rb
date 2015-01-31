class Rolodex
  attr_reader :contacts

  def initialize
    @contacts = []
    @id = 1000
  end

  def add_contact(contact)
    contact.id = @id
    @contacts << contact
    @id += 1
  end

  def find_contact(id)
    @contacts.find { |contact| contact.id == id }
  end

  def remove_contact(contact)
    @contacts.delete(contact)
  end
end