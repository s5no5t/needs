require 'spec_helper'

describe "requirements/new" do
  before(:each) do
    assign(:requirement, stub_model(Requirement,
      :title => "MyString",
      :body => "MyText"
    ).as_new_record)
  end

  it "renders new requirement form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => requirements_path, :method => "post" do
      assert_select "input#requirement_title", :name => "requirement[title]"
      assert_select "textarea#requirement_body", :name => "requirement[body]"
    end
  end
end
