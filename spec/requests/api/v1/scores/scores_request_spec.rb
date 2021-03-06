require 'rails_helper'

describe "Scores API" do
  describe "User requests scores and scores exist for each difficulty level" do
    it "returns average scores for each difficulty level" do
      user = create(:user)
      user.scores.create!(difficulty: 1, num_played: 10, num_correct: 8)
      user.scores.create!(difficulty: 1, num_played: 10, num_correct: 6)
      user.scores.create!(difficulty: 2, num_played: 10, num_correct: 6)
      user.scores.create!(difficulty: 2, num_played: 10, num_correct: 4)
      user.scores.create!(difficulty: 3, num_played: 10, num_correct: 4)
      user.scores.create!(difficulty: 3, num_played: 10, num_correct: 2)

      get "/api/v1/users/#{user.id}/scores"

      expect(response).to have_http_status(200)
      scores = JSON.parse(response.body)

      expect(scores.count).to eq(3)
      expect(scores["easy"]).to eq("70.0%")
      expect(scores["medium"]).to eq("50.0%")
      expect(scores["hard"]).to eq("30.0%")
    end
  end

  describe "User requests scores and a difficulty level has zero score" do
    it "returns 'No scores recorded.' for difficulty levels without scores" do
      user = create(:user)
      user.scores.create!(difficulty: 1, num_played: 10, num_correct: 8)
      user.scores.create!(difficulty: 1, num_played: 10, num_correct: 6)
      user.scores.create!(difficulty: 3, num_played: 10, num_correct: 4)
      user.scores.create!(difficulty: 3, num_played: 10, num_correct: 2)

      get "/api/v1/users/#{user.id}/scores"

      expect(response).to have_http_status(200)
      scores = JSON.parse(response.body)

      expect(scores.count).to eq(3)
      expect(scores["easy"]).to eq("70.0%")
      expect(scores["medium"]).to eq("No scores recorded.")
      expect(scores["hard"]).to eq("30.0%")
    end
  end
end
