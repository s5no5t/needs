collection @requirements
attributes :id, :title, :body
node(:url) {|r| requirement_path(r)}