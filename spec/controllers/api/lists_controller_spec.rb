require 'rails_helper'

RSpec.describe ListsController, type: :controller do
  before do
    @list = create(:list, user_id: @user.id)
    @list1 = create(:list, user_id: @user1.id)
  end
  
  describe "GET #index" do
    context "when valid" do
      before do
        get :index, format: :json, params: { id: @user.id }
      end
      
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      
      it "JSON body response contains expected lists attributes" do
        expect(json.first.keys).to match_array(["created_at", "description", "id", "name", "public", "updated_at", "user_id"])
      end

      it "JSON body response contains expected list name" do
        expect(json.first['name']).to eq(@list.name)
      end
      
      it "JSON body response contains expected list description" do
        expect(json.first['description']).to eq(@list.description)
      end

      it "JSON body response contains expected list id" do
        expect(json.first['id']).to eq(@list.id)
      end

      it "JSON body response contains expected list state" do
        expect(json.first['public']).to eq(@list.public)
      end

      it "JSON body response contains user id of expected list" do
        expect(json.first['user_id']).to eq(@user.id)
      end
    end

    context "when invalid" do
      context "when the user does not authenticate", :nil_token do
        before do
          get :index, format: :json, params: { id: @user.id }
          @nil_token = { "errors" => "Nil JSON web token" }
        end
  
        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "returns an error if token is nil" do
          expect(json).to eq(@nil_token)
        end
      end

      context "when the user does not exist" do
        before do
          get :index, format: :json, params: { id: "False id" }
        end
        
        it "returns http unauthorized" do
          expect(response).to have_http_status(:not_found)
        end

        it "The user does not exist" do
          expect(json['message']).to eq('The user does not exist')
        end
      end
    end

    context "when the user's token does not match the user to display" do
      before do      
        get :index, format: :json, params: { id: @user1.id }
      end

      it "returns http unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
      
      it "The user cannot modify other users" do
        expect(json['message']).to eq("You cannot see other users' lists")
      end
    end
  end
  
  describe "GET #show" do
    context "when valid" do
      before do
        get :show, format: :json, params: { id: @list.id }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "JSON body response contains expected lists attributes" do
        expect(json.keys).to match_array(["created_at", "description", "id", "name", "public", "updated_at", "user_id", "movies"])
      end
      
      it "JSON body response contains expected list name" do
        expect(json['name']).to eq(@list.name)
      end
      
      it "JSON body response contains expected list description" do
        expect(json['description']).to eq(@list.description)
      end

      it "JSON body response contains expected list id" do
        expect(json['id']).to eq(@list.id)
      end

      it "JSON body response contains expected list state" do
        expect(json['public']).to eq(@list.public)
      end

      it "JSON body response contains user id of expected list" do
        expect(json['user_id']).to eq(@user.id)
      end
    end

    context "when invalid" do
      context "when the user does not authenticate", :nil_token do
        before do
          get :show, format: :json, params: { id: @user.id }
          @nil_token = { "errors" => "Nil JSON web token" }
        end
  
        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "returns an error if token is nil" do
          expect(json).to eq(@nil_token)
        end
      end
    end
    
    context "when the list does not exist" do
      before do
        get :show, format: :json, params: { id: "False id" }
      end
      
      it "returns http unauthorized" do
        expect(response).to have_http_status(:not_found)
      end

      it "The user does not exist" do
        expect(json['message']).to eq('The list does not exist')
      end
    end

    context "when the user's token does not match the user to display" do
      before do
        get :show, format: :json, params: { id: @list1.id }
      end
      it "returns http unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
      it "The user does not exist" do
        expect(json['message']).to eq("You cannot see other users' lists")
      end
    end
  end

  describe "POST #create" do
    before do
      @created_list = { 
        "message" => "Created List",
        "data" => { 
          "id" => 9,
          "name" => "Create list",
          "description" => "This is my list",
          "public" => false,
          "user_id" => 1,
          "created_at" => "2020-07-01T22:01:58.137Z",
          "updated_at" => "2020-07-01T22:01:58.137Z" 
          }
        }
      
      @description_blank = {
        "message" => "List not created",
        "data" => {
          "description" => ["can't be blank"] 
          }
        }
      
        @name_blank = { 
        "message" => "List not created",
        "data" => {
          "name" => ["can't be blank"] 
          }
        }

      @public_blank = {
        "message" => "List not created",
        "data" => { 
          "public" => ["is not included in the list","is reserved"] 
        }
      }
    end

    context "when valid" do
      it "The list has been created successfully" do
        expect(@created_list['message']).to eq('Created List')
      end
    end

    context "when invalid" do
      it "The list has not been created successfully" do
        expect(@description_blank['message']).to eq('List not created')
      end
      
      context "when blank fields" do
        it "The list can't be blank" do
          expect(@description_blank['data']['description']).to eq(["can't be blank"])
        end

        it "The list name can't be blank" do
          expect(@name_blank['data']['name']).to eq(["can't be blank"])
        end
        
        it "The list state can't be blank" do
          expect(@public_blank['data']['public']).to eq(["is not included in the list","is reserved"])
        end
      end
    end
  end

  describe "PUT #update" do
    context "when valid" do
      before do
        @new_name = "New name"
        put :update, format: :json, params: { id: @list.id, name: @new_name }
      end

      it "returns http no content" do
        expect(response).to have_http_status(:no_content)
      end

      it "The list has been updated successfully" do
        expect(json['message']).to eq('Updated list')
      end

      it "JSON body response contains expected list name" do
        expect(json['data']['name']).to eq(@new_name)
      end
    end

    context "when invalid" do
      context "when the user does not authenticate", :nil_token do
        before do
          put :update, format: :json, params: { id: @list.id, name: "New name" }
          @nil_token = { "errors" => "Nil JSON web token" }
        end
  
        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "returns an error if token is nil" do
          expect(json).to eq(@nil_token)
        end
      end
      
      context "when the list does not exist" do
        before do 
          put :update, format: :json, params: { id: "False id", name: "New name" }
        end
        
        it "returns http unauthorized" do
          expect(response).to have_http_status(:not_found)
        end
  
        it "The list does not exist" do
          expect(json['message']).to eq('The list does not exist')
        end
      end
      
      context "when the user's token does not match the user to display" do
        before do
          put :update, format: :json, params: { id: @list1.id, name: "New name" }
        end

        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "The user does not exist" do
          expect(json['message']).to eq("You cannot update other users lists")
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context "when valid" do
      context "when the list has been deleted " do
        before do 
          delete :destroy, format: :json, params: { id: @list.id }
        end

        it "The list has been deleted successfully" do
          expect(json['message']).to eq('The list has been deleted')
        end

        it "The list doesn't exist anymore" do 
          get :show, format: :json, params: { id: @list.id }
          expect(json['message']).to eq('The list does not exist')
        end
      end     
    end

    context "when invalid" do
      context "when the user does not authenticate", :nil_token do
        before do 
          delete :destroy, format: :json, params: { id: @list.id }
          @nil_token = { "errors" => "Nil JSON web token" }
        end

        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "returns an error if token is nil" do
          expect(json).to eq(@nil_token)
        end
      end
      
      context "when the list cannot be deleted" do
        before do 
          delete :destroy, format: :json, params: { id: "False_id" }
        end
        
        it "returns http not found" do
          expect(response).to have_http_status(:not_found)
        end
        
        it "The list does not exist" do
          expect(json['message']).to eq('The list does not exist')
        end
      end
      
      context "when the user's token does not match the user to display" do
        before do
          delete :destroy, format: :json, params: { id: @list1.id }
        end

        it "returns http unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end
        
        it "The user does not exist" do
          expect(json['message']).to eq("You cannot delete other users lists")
        end
      end
    end
  end

  describe "Movies and Lists" do
    before do
      @movie = create(:movie)
      @list = create(:list, user_id: @user.id)
      @list1 = create(:list, user_id: @user1.id)
    end
    
    describe "PUT #add_movie" do
      context "when valid" do
        before do
          put :add_movie, format: :json, params: { movie_id: @movie.id, list_id: @list.id }
        end

        it "returns http no content" do
          expect(response).to have_http_status(:no_content)
        end

        it "The movie has been successfully added to the list" do
          expect(json['message']).to eq('The movie has been successfully added to the list')
        end
      end
    
      context "when invalid" do
        context "when the user does not authenticate", :nil_token do
          before do
            put :add_movie, format: :json, params: { movie_id: @movie.id, list_id: @list.id }
            @nil_token = { "errors" => "Nil JSON web token" }
          end
    
          it "returns http unauthorized" do
            expect(response).to have_http_status(:unauthorized)
          end
  
          it "returns an error if token is nil" do
            expect(json).to eq(@nil_token)
          end
        end
        
        context "when the list does not exist" do
          before do
            put :add_movie, format: :json, params:  { list_id: "False id", movie_id: @movie.id }
          end
          
          it "returns http unauthorized" do
            expect(response).to have_http_status(:not_found)
          end
    
          it "The list  does not exist" do
            expect(json['message']).to eq('The list does not exist')
          end
        end

        context "when the movie does not exist" do
          before do
            put :add_movie, format: :json, params:  { list_id: @list.id, movie_id: "False id" }
          end
          
          it "returns http unauthorized" do
            expect(response).to have_http_status(:not_found)
          end
    
          it "The movie does not exist" do
            expect(json['message']).to eq('The movie does not exist')
          end
        end
        
        context "when the user's token does not match the user to display" do
          before do
            put :add_movie, format: :json, params: { movie_id: @movie.id, list_id: @list1.id }   
          end

          it "returns http unauthorized" do
            expect(response).to have_http_status(:unauthorized)
          end

          it "The user does not exist" do
            expect(json['message']).to eq("You cannot add movies to other users' lists")
          end
        end
        
        context "when the movie is already added to the list" do
          before do
            @list = create(:list, user_id: @user.id, movies: [@movie])
            put :add_movie, format: :json, params: { movie_id: @movie.id, list_id: @list.id }      
          end

          it "returns http unauthorized" do
            expect(response).to have_http_status(:unprocessable_entity)
          end
          
          it "The movie is already added to the list" do
            expect(json['message']).to eq("The movie has already been added to this list")
          end
        end
      end
    end

    describe "DELETE #remove_movie" do
      context "when valid" do
        before do
          @list = create(:list, user_id: @user.id, movies: [@movie])
          delete :remove_movie, format: :json, params: { movie_id: @movie.id, list_id: @list.id }         
        end

        it "returns http no content" do
          expect(response).to have_http_status(:no_content)
        end

        it "The movie has been successfully removed from the list" do
          expect(json['message']).to eq('The movie has been successfully removed from this list')
        end
      end
      
      context "when invalid" do
        context "when the user does not authenticate", :nil_token do
          before do
            delete :remove_movie, format: :json, params: { movie_id: @movie.id, list_id: @list.id }          
            @nil_token = { "errors" => "Nil JSON web token" }
          end
    
          it "returns http unauthorized" do
            expect(response).to have_http_status(:unauthorized)
          end
  
          it "returns an error if token is nil" do
            expect(json).to eq(@nil_token)
          end
        end
        
        context "when the movie does not exist" do
          before do
            delete :remove_movie, format: :json, params:  { list_id: @list.id, movie_id: "False id" }            
          end
          
          it "returns http unauthorized" do
            expect(response).to have_http_status(:not_found)
          end
    
          it "The movie does not exist" do
            expect(json['message']).to eq('The movie does not exist')
          end
        end

        context "when the list does not exist" do
          before do
            delete :remove_movie, format: :json, params:  { list_id: "False id", movie_id: @movie.id }           
          end
          
          it "returns http unauthorized" do
            expect(response).to have_http_status(:not_found)
          end
    
          it "The list does not exist" do
            expect(json['message']).to eq('The list does not exist')
          end
        end
        
        context "when the user's token does not match the user to display" do
          before do
            delete :remove_movie, format: :json, params: { movie_id: @movie.id, list_id: @list1.id }            
          end

          it "returns http unauthorized" do
            expect(response).to have_http_status(:unauthorized)
          end

          it "The user does not exist" do
            expect(json['message']).to eq("You cannot delete movies from other users' lists")
          end
        end

        context "when the movie is not in the list" do
          before do
            @list = create(:list, user_id: @user.id)
            delete :remove_movie, format: :json, params: { movie_id: @movie.id, list_id: @list.id }
          end

          it "returns http unauthorized" do
            expect(response).to have_http_status(:unprocessable_entity)
          end
          
          it "The movie is already removed from the list" do
            expect(json['message']).to eq("The movie is not in this list")
          end
        end
      end
    end
  end
end
