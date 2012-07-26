require 'spec_helper'
include Devise::TestHelpers
 
describe "Blogs" do
  describe "blogging" do
    let(:admin) { User.create!(email: "admin@test.com",
                               password: "secrat",
                               role: 'admin') }
    let(:mentor) { User.create!(email: "mentor@test.com",
                                password: "secrat",
                                role: 'mentor') }
    let(:member) { User.create!(email: "member@test.com",
                                password: "secrat",
                                role: 'member') }
    context 'as a mentor' do
      before(:each) do
        visit posts_path
        click_link 'Sign in'
        within "form" do
          fill_in "Email", with: mentor.email
          fill_in "Password", with: mentor.password
          click_button 'Sign in'
        end
      end

      it 'allows a mentor to create a post' do
        visit posts_path
        click_link 'New Post'
        fill_in "Name", with: "Test"
        fill_in "Title", with: "Test Title"
        fill_in "Content", with: "Lorem ipsum blabhalbhalhblahblh"
        click_button "Create Post"
        page.should have_content("Lorem ipsum blabhalbhalhblahblh")
      end
      
      context "owns a post" do
        before(:each) do 
          Post.create!(content: "blah blah",
                       name: "nice post",
                       title: "coolness",
                       user_id: mentor.id)
        end
        
        it 'allows a mentor to edit their post' do
#         binding.pry
          visit posts_path
          page.should have_content "Edit"
        end
      end

      context "does not own a post" do
        before(:each) do 
          Post.create!(content: "blah blah",
                       name: "nice post",
                       title: "coolness",
                       user_id: admin.id)
        end
        it 'does not allow a mentor to edit another post' do
          visit posts_path
          page.should_not have_content "Edit"
        end
      end
    end

    context 'as a guest' do
      it 'does not allow creation of posts' do
        visit posts_path
        page.should_not have_content("New Post")
      end
      context "posts exist" do
        before(:each) do 
          post = Post.create!(content: "blah blah",
                              name: "nice post",
                              title: "coolness",
                              user_id: mentor.id)
          
        end
        it "does not allow editing" do
          visit posts_path
          page.should_not have_content "Edit"
        end
      end
    end

    context 'as a member' do
      before(:each) do

        visit posts_path
        click_link 'Sign in'
        within "form" do
          fill_in "Email", with: member.email
          fill_in "Password", with: member.password
          click_button 'Sign in'
        end
      end
      
      it 'does not allow a member to create posts' do
        pending
        visit posts_path
        page.should_not have_content("New Post")
      end
      context "posts exist" do
        before(:each) do 
          Post.create!(content: "blah blah",
                       name: "nice post",
                       title: "coolness",
                       user_id: member.id)
        end

        it 'does not allow a member to edit any post' do
          visit posts_path
          page.should_not have_content "Edit"
        end
      end
    end
    
    context "as an admin" do
      before(:each) do
        visit posts_path
        click_link 'Sign in'
        within "form" do
          fill_in "Email", with: admin.email
          fill_in "Password", with: admin.password
          click_button 'Sign in'
        end
      end
      
      it 'allows an admin to create a post' do
        visit posts_path
        click_link 'New Post'
        fill_in "Name", with: "Test"
        fill_in "Title", with: "Test Title"
        fill_in "Content", with: "Lorem ipsum blabhalbhalhblahblh"
        click_button "Create Post"
        page.should have_content("Lorem ipsum blabhalbhalhblahblh")
      end
      context "with mentor posts" do
        before(:each) do 
          post = Post.create!(content: "blah blah",
                              name: "nice post",
                              title: "coolness",
                              user_id: mentor.id)
        end       
        it 'allows an admin to edit mentors post' do
          visit posts_path
          page.should have_content "Edit"
        end
      end
      context "with self posts" do
        before(:each) do 
          Post.create!(content: "blah blah",
                       name: "nice post",
                       title: "coolness",
                       user_id: admin.id)
        end
        it "allows an admin to edit self posts" do
          visit posts_path
          page.should have_content "Edit"
        end
      end
    end
  end
end
