require 'net/ldap'

module OmniAuth
  module Strategies
    class LDAP
      include OmniAuth::Strategy

      def request_phase
        if env['REQUEST_METHOD'] == 'GET'
          OmniAuth::Form.build(:title => "LDAP Authentication") {
            text_field 'Login', 'username'
            password_field 'Password', 'password'
          }.to_response
        else # POST
          session['omniauth.ldap'] = {'username' => request['username'], 'password' => request['password']}
          redirect callback_path
        end
      end

      def callback_phase
        username = session['omniauth.ldap']['username']
        password = session['omniauth.ldap']['password']

        ldap = Net::LDAP.new(:host => options[:host], :port => options[:port],
          :auth => {
            :method => options[:auth],
            :username => "#{options[:uid]}=#{username},#{options[:base]}",
            :password => password
        })

        ldap.bind
        if ldap.get_operation_result.code == 0
          @uid = username
          @ldap_user_info = ldap.search(:base => options[:base],
            :filter => Net::LDAP::Filter.eq(options[:uid], username),
            :limit => 1).first || {}

          super
        else
          fail!(:invalid_credentials)
        end
      end

      def auth_hash
        OmniAuth::Utils.deep_merge(super, {
          'uid' => @uid,
          'user_info' => {
            'name' => @ldap_user_info['displayname'].first,
            'mail' => @ldap_user_info['mail'].first
          },
          'extra' => {}
        })
      end
    end
  end
end

OmniAuth.config.add_camelization 'ldap', 'LDAP'
