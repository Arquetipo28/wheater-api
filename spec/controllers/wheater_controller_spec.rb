# frozen_string_literal: true

RSpec.describe Api::WheaterController, type: :controller do
  describe 'routing' do
    it { is_expected.to route(:get, 'api/wheater/min').to(controller: 'api/wheater', action: :show_min) }
    it { is_expected.to route(:get, 'api/wheater').to(controller: 'api/wheater', action: :show) }
  end

  describe 'GET min' do
    it 'should return min wheater if exist' do
      create(:wheater)
      get :show_min

      json_data = JSON.parse(response.body)
      temp = json_data.dig('data', 'value', 'temp')
      expect(response.status).to eq 200
      expect(json_data['data'].blank?).to be_falsey
      expect(temp).to eq 16.5
    end

    it 'should return blank response withoud min wheater' do
      get :show_min

      json_data = JSON.parse(response.body)
      temp = json_data.dig('data', 'value', 'temp')

      expect(json_data&.[]('data').blank?).to be
      expect(temp.nil?).to be_truthy
      expect(json_data['error']).to be_kind_of(String)
    end
  end

  describe 'GET show' do
    it 'should return historical wheater' do
      2.times do
        create(:wheater)
      end

      get :show

      json_data = JSON.parse(response.body)
      wheater_data = json_data.dig('data', 'wheater')

      expect(json_data).to include('data')
      expect(wheater_data).to be_kind_of(Array)
      expect(wheater_data.blank?).to be_falsey
      expect(wheater_data.length).to eq 2
    end

    it 'should return empty historical wheater' do
      get :show

      json_data = JSON.parse(response.body)
      wheater_data = json_data.dig('data', 'wheater')

      expect(json_data).to include('data')
      expect(wheater_data).to be_kind_of(Array)
      expect(wheater_data.blank?).to be_truthy
    end

    context 'with filters' do
      before :each do
        first_wheater_record = create(:wheater)
        create(:wheater, temp: 10.3, created_at: first_wheater_record.created_at + 1.hour)
      end

      it 'should return historical wheater ordered by temp asc' do
        get :show, params: {
          temp: 'asc'
        }

        json_data = JSON.parse(response.body)
        wheater_data = json_data.dig('data', 'wheater')

        expect(json_data).to include('data')
        expect(wheater_data).to be_kind_of(Array)
        expect(wheater_data.blank?).to be_falsey
        expect(wheater_data[0]['temp']).to eq 10.3
      end

      it 'should return historical wheater ordered by temp desc' do
        get :show, params: {
          temp: 'desc'
        }

        json_data = JSON.parse(response.body)
        wheater_data = json_data.dig('data', 'wheater')

        expect(json_data).to include('data')
        expect(wheater_data).to be_kind_of(Array)
        expect(wheater_data.blank?).to be_falsey
        expect(wheater_data[0]['temp']).to eq 16.5
      end

      it 'should return historical wheater ordered by created_at asc' do
        get :show, params: {
          created_at: 'asc'
        }

        json_data = JSON.parse(response.body)
        wheater_data = json_data.dig('data', 'wheater')

        expect(json_data).to include('data')
        expect(wheater_data).to be_kind_of(Array)
        expect(wheater_data.blank?).to be_falsey
        expect(wheater_data[0]['created_at'] < wheater_data[1]['created_at']).to be_truthy
      end

      it 'should return historical wheater ordered by created_at desc' do
        get :show, params: {
          created_at: 'desc'
        }

        json_data = JSON.parse(response.body)
        wheater_data = json_data.dig('data', 'wheater')

        expect(json_data).to include('data')
        expect(wheater_data).to be_kind_of(Array)
        expect(wheater_data.blank?).to be_falsey
        expect(wheater_data[0]['created_at'] > wheater_data[1]['created_at']).to be_truthy
      end
    end
  end
end
