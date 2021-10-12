# Command-Line Demo
This is a brief command-line demo to show how the [Valkyrie](https://github.com/samvera/valkyrie) API works.

## setup an application
follow the initial [steps to generate a new application and add valkyrie](https://github.com/awead/valkyrie-rails-workshop/) — the short version is:
```sh
$ gem install rails bundler
$ git clone https://github.com/bess/valkyrie-rails-workshop
$ cd valkyrie-rails-workshop
$ rails new library-repo -m template.rb -T -d postgresql
$ cd library-repo
$ echo "gem 'valkyrie'" >> Gemfile
$ bundle install
```

## start an interactive ruby session
```
$ bundle exec rails console
```

## setup our persistence
```
metadata = Valkyrie::Persistence::Memory::MetadataAdapter.new
files = Valkyrie::Storage::Memory.new
```

## define some models
```
class Page < Valkyrie::Resource
  attribute :title
  attribute :file_identifiers, Valkyrie::Types::Set
end

class Book < Valkyrie::Resource
  attribute :title
  attribute :member_ids, Valkyrie::Types::Array.meta(ordered: true)
end
```

## create some objects
```
page1 = Page.new(title: "page 1")
page2 = Page.new(title: "page 2")
saved_page1 = metadata.persister.save(resource: page1)
saved_page2 = metadata.persister.save(resource: page2)

book1 = Book.new(title: "I Like Short Books", member_ids: [saved_page1.id, saved_page2.id])
saved_book1 = metadata.persister.save(resource: book1)
```

## queries
```
metadata.query_service.find_all
metadata.query_service.find_all_of_model(model: Book)
metadata.query_service.find_by(id: saved_page1.id)
metadata.query_service.find_members(resource: saved_book1)
metadata.query_service.find_parents(resource: saved_page1)
```

## deleting objects
```
metadata.persister.delete(resource: saved_book1)
metadata.query_service.find_by(id: saved_book1.id)
```

## uploading files
```
page3 = Page.new(title: "page 3")
saved_page3 = metadata.persister.save(resource: page3)
tempfile = File.new("../v2hex.png")
file = files.upload(file: tempfile, original_filename: "v2hex.png", resource: saved_page3)
saved_page3.file_identifiers = [file.id]
updated_page3 = metadata.persister.save(resource: saved_page3)
```

## finding files
```
retrieved_file = files.find_by(id: updated_page3.file_identifiers.first)
retrieved_file.size
retrieved_file.checksum(digests: [Digest::SHA256.new, Digest::MD5.new])
retrieved_file.valid?(size: 55606, digests: {md5: "512662d26090afe25bd69fdf5926c2f6"})
  => false
retrieved_file.valid?(size: 131765, digests: {md5: "512662d26090afe25bd69fdf5926c2f6"})
  => true
retrieved_file.valid?(size: 131765, digests: {sha256: "a9a6ef6e55f65e276f4e591329e688bd33fc11ebbe9b3381996b8c53cf777f3f"})
  => true
```

## deleting files
```
files.delete(id: retrieved_file.id)
```
