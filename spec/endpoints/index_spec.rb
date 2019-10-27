require 'spec_helper'

describe 'A user sends request to /', type: :feature do
  scenario 'They see a message telling them the API is private' do
    get '/'

    expect(last_response).to be_successful
    expect(last_response.body).to have_content('Fantasy Fortuneteller API')
    expect(last_response.body).to have_content('This API is currently not open to the public')
  end
end
