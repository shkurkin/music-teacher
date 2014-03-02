require 'spec_helper'

describe 'Adding contacts' do
  describe 'viewing all contacts' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:contact) { FactoryGirl.create(:contact) }
    before(:each) do
      visit user_contacts_path user
    end
    it 'displays all contacts' do
      expect(page).to have_content "#{contact.first_name}"
      expect(page).to have_content "#{contact.last_name}"
    end
    it 'should allow me to navigate to the create contact page' do
      expect(page).to have_content 'Add New Contact'
      click_on 'Add New Contact'
      expect(current_path).to eq new_contact_path
    end
  end
  describe 'contact creation form' do
    before(:each) do
      visit contacts_path
      click_on 'Add New Contact'
    end
    it 'should have the correct fields' do
      expect(page).to have_button 'Create Contact'
      expect(page).to have_field 'contact_first_name'
      expect(page).to have_field 'contact_last_name'
      expect(page).to have_field 'contact_email'
      expect(page).to have_field 'contact_address'
      expect(page).to have_field 'contact_phone'
    end
    describe 'adding a contact' do
      let!(:contact_params) { FactoryGirl.attributes_for(:contact) }
      context 'with valid params' do
        it 'display all contacts page with newly added contact' do
          fill_in 'contact_first_name',  with: contact_params[:first_name]
          fill_in 'contact_last_name',   with: contact_params[:last_name]
          fill_in 'contact_email',       with: contact_params[:email]
          fill_in 'contact_address',     with: contact_params[:address]
          fill_in 'contact_phone',       with: contact_params[:phone]
          click_on 'Create Contact'
          expect(page).to have_content "#{contact_params[:first_name]}"
          expect(page).to have_content "#{contact_params[:last_name]}"
        end
      end
      context 'with invalid params' do
        before(:each) do
          fill_in 'contact_last_name',   with: contact_params[:last_name]
          fill_in 'contact_email',       with: contact_params[:email]
          fill_in 'contact_address',     with: contact_params[:address]
          fill_in 'contact_phone',       with: contact_params[:phone]
          click_on 'Create Contact'
        end
        it 'shows the add contact page' do
          expect(page).to have_content 'Add New Contact'
        end
        it 'adds "field_with_errors" class to page' do
          expect(page).to have_css '.field_with_errors'
        end
      end
    end
  end
  describe 'viewing a specific contact' do
    let!(:contact) { FactoryGirl.create(:contact) }
    it 'should show all of a contact\'s information after clicking on the name' do
      visit contacts_path
      click_on "#{contact.first_name}"
      expect(page).to have_content contact.first_name
      expect(page).to have_content contact.last_name
      expect(page).to have_content contact.email
      expect(page).to have_content contact.address
      expect(page).to have_content contact.phone
    end
  end
  describe 'editing contacts' do
  end
end
