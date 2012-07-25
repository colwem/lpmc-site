require 'spec_helper'
include Devise::TestHelpers

describe "Blogs" do
	describe "blogging" do
		context 'as a mentor' do
			before(:each) do
				user = User.create!(email: "test@test.com", password: "secrat", role: 'mentor')
				visit posts_path
				click_link 'Sign in'
				within "form" do 
					fill_in "Email", with: user.email
					fill_in "Password", with: user.password
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

		end

		context 'as a guest' do
			it 'does not allow creation of posts' do
				visit posts_path
				page.should_not have_content("New Post")
			end
		end

		context 'as a member' do
			before(:each) do
				user = User.create!(email: "test@test.com", password: "secrat", role: 'member')
				visit posts_path
				click_link 'Sign in'
				within "form" do 
					fill_in "Email", with: user.email
					fill_in "Password", with: user.password
					click_button 'Sign in'
				end
			end
			it 'does not allow a member to create posts' do
				pending
				visit posts_path
				page.should_not have_content("New Post")
			end
		end
	end
end
