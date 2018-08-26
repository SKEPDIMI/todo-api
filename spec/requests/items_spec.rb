require 'rails_helper'

RSpec.describe 'Item API', type: :request do
  # initialize data
  let(:user) { create(:user) }
  let!(:todo) { create(:todo, created_by: user.id) } # todo = { id: 1, title: 'Hello, world', created_by: 1 }
  let!(:items) { create_list(:item, 20, todo_id: todo.id) } # items = [ { id: 1, todo_id: 1 }, { id: 2, todo_id: 1 } ... ]
  let(:todo_id) { todo.id }
  let(:id) { items.first.id }
  let(:headers) { valid_headers }

  describe 'GET /todos/:todo_id/items' do
    before { get "/todos/#{todo_id}/items", params: {}, headers: headers }

    context 'when todo exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end
      it 'returns all todo items' do
        expect(json.size).to eq(20)
      end
    end

    context 'when does not exist' do
      let(:todo_id) { 0 }
      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end
      it 'returns a not found message' do
        expect(response.body).not_to be_empty
      end
    end
  end

  describe 'GET /todos/:todo_id/items/:id' do
    before { get "/todos/#{todo_id}/items/#{id}", params: {}, headers: headers  }

    context 'when item exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end
      it 'returns item request' do
        # Change this to look for item.name
        expect(json).not_to be_empty
      end
    end

    context 'when item does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end
      it 'returns a not found message' do
        expect(response.body).not_to be_empty
      end
    end
  end

  describe 'POST todos/:todo_id/items' do
    let(:valid_attributes) { { name: 'Visit Narnia', done: false }.to_json } 

    context 'when attributes are valid' do
      before { post "/todos/#{todo_id}/items", params: valid_attributes, headers: headers }

      it 'returns 201' do
        expect(response).to have_http_status 201
      end
    end

    context 'when attributes are invalid' do
      before { post "/todos/#{todo_id}/items", params: { name: nil }.to_json, headers: headers }

      it 'returns 422' do
        expect(response).to have_http_status 422
      end
    end
  end

  describe 'PUT todos/:todo_id/items/:id' do
    let(:valid_attributes) { { name: 'Mozart' }.to_json }

    before do 
      put "/todos/#{todo_id}/items/#{id}", params: valid_attributes, headers: headers
    end

    context 'when item exists' do
      it 'returns status codes 204' do
        expect(response).to have_http_status 204
      end
      it 'updates the item' do
        updated_item = Item.find(id)
        expect(updated_item.name).to match(/Mozart/)
      end
    end
    context 'when item does not exist' do
      let (:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end
      it 'returns a not found message' do
        expect(response.body).not_to be_empty
      end
    end
  end

  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}/items/#{id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status 204
    end
  end
end