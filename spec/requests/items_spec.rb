require 'rails_helper'

RSpec.describe 'Item API', type: :request do
  # initialize data
  let!(:todo) { create(:todo) } # todo = { id: 1, title: 'Hello, world', created_by: 1 }
  let!(:items) { create_list(:item, 20, todo_id: todo.id) } # items = [ { id: 1, todo_id: 1 }, { id: 2, todo_id: 1 } ... ]
  let(:todo_id) { todo.id }
  let(:id) { items.first.id }

  describe 'GET /todos/:todo_id/items' do
    before { get "/todos/#{todo_id}/items" }

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
    before { get "/todos/#{todo_id}/items/#{id}" }

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

  describe 'PUT todos/:todo_id/items/:id' do
    let(:valid_attributes) { { name: 'Mozart' } }

    before { put "/todos/#{todo_id}/items/#{id}", params: valid_attributes }

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
    before { delete "/todos/#{todo_id}/items/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status 204
    end
  end
end