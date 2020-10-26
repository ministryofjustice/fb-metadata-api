RSpec.shared_examples 'application authentication' do
  let(:params) { {} }

  context 'when token not present' do
    before do
      allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_raise(
        Fb::Jwt::Auth::TokenNotPresentError, 'Token is not present'
      )
      action
    end

    it 'returns unauthorised' do
      expect(response.status).to be(401)
    end

    it 'returns response body' do
      expect(response_body).to eq('message' => ['Token is not present'])
    end
  end

  context 'when application not present ' do
    before do
      allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_raise(
        Fb::Jwt::Auth::IssuerNotPresentError, 'Issuer is not present'
      )
      action
    end

    it 'returns unauthorised' do
      expect(response.status).to be(401)
    end

    it 'returns response body' do
      expect(response_body).to eq('message' => ['Issuer is not present'])
    end
  end

  context 'when namespace not present' do
    before do
      allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_raise(
        Fb::Jwt::Auth::NamespaceNotPresentError, 'Namespace is not present'
      )
      action
    end

    it 'returns unauthorised' do
      expect(response.status).to be(401)
    end

    it 'returns response body' do
      expect(response_body).to eq('message' => ['Namespace is not present'])
    end
  end

  context 'when token is not valid' do
    before do
      allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_raise(
        Fb::Jwt::Auth::TokenNotValidError, 'Token is not valid'
      )
      action
    end

    it 'returns unauthorised' do
      expect(response.status).to be(401)
    end

    it 'returns response body' do
      expect(response_body).to eq('message' => ['Token is not valid'])
    end
  end

  context 'when token is expired' do
    before do
      allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_raise(
        Fb::Jwt::Auth::TokenExpiredError, 'Token has expired'
      )
      action
    end

    it 'returns unauthorised' do
      expect(response.status).to be(401)
    end

    it 'returns response body' do
      expect(response_body).to eq('message' => ['Token has expired'])
    end
  end
end