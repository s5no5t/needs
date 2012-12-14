require 'spec_helper'

describe "requirements/edit" do
  before(:each) do
    @requirement = assign(:requirement, stub_model(Requirement,
      :title => "MyString",
      :body => "MyText"
    ))
  end

  it "renders the edit requirement form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => requirements_path(@requirement), :method => "post" do
      assert_select "input#requirement_title", :name => "requirement[title]"
      assert_select "textarea#requirement_body", :name => "requirement[body]"
    end
  end
end
