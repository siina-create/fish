class TwoFactorAuthsController < ApplicationController
  # 2段階認証有効化確認
  def new
    unless current_user.otp_secret
      current_user.otp_secret = User.generate_otp_secret(32)
      current_user.save!
    end
    @qr_code = build_qr_code
  end

  # 2段階認証有効化
  def create
    if current_user.validate_and_consume_otp!(params[:otp_attempt])
      current_user.otp_required_for_login = true
      current_user.save!

      redirect_to root_path

    else
      @error = 'Invalid pin code'
      @qr_code = build_qr_code

      render 'new'
    end
  end

  # 2段階認証無効化
  def destroy
    current_user.update_attributes(
      otp_required_for_login:    false,
      encrypted_otp_secret:      nil,
      encrypted_otp_secret_iv:   nil,
      encrypted_otp_secret_salt: nil,
    )
    redirect_to root_path
  end

  private
  
  def build_qr_code
    label = "service_name"
    # issuerでGoogle Authenticator上の登録サービス名として表示
    issuer ="company_name"
    uri = current_user.otp_provisioning_uri(label, issuer: issuer)
    qrcode = RQRCode::QRCode.new(uri)
    qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 2
    )
  end
end
