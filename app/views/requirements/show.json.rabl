object @requirement
attributes :id, :title, :body
node(:url) {|r| requirement_path(r)}
child :derived_requirements => 'derived_requirements' do
	attributes :id, :title, :body
	node(:url) {|r| requirement_path(r)}
end
child :deriving_requirements => 'deriving_requirements' do
	attributes :id, :title, :body
	node(:url) {|r| requirement_path(r)}
end
