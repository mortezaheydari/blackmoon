require 'spec_helper'

describe "Event" do 
	let(:account) { FactoryGirl.create(:account_with_user) }	
	let(:user) {account.user}
	let(:event) { FactoryGirl.create(:event) }
	
	subject { page }

	describe "index page" do
    before { visit events_path }		
		it { should have_selector('h1', text: 'All events') }
  end

	describe "show page" do
		before { visit event_path(event.id) }
		it { should have_selector('h1', text: 'Events#show') }
  end

	describe "create page" do
		before { visit new_event_path }
		it { should have_selector('h1', text: 'Events#new') }
  end

	describe "edit page" do
		before { visit edit_event_path(event.id) }
		it { should have_selector('h1', text: 'Events#edit') }
  end    
 
end