class Settings::TokensController < ApplicationController
  before_action :set_access_token, only: [:show, :edit, :update, :destroy]

  # GET /settings/tokens
  def index
    @access_tokens = personal_access_tokens
  end

  # GET /settings/tokens/new
  def new
    @access_token = personal_access_tokens.build
  end

  # GET /settings/tokens/1/edit
  def edit
  end

  # POST /settings/tokens
  def create
    @access_token = personal_access_tokens.build(access_token_params)

    if @access_token.save
      notice = <<-EOS.strip_heredoc
        Make sure to copy your new personal access token now. You won't be able to see it again!
        #{@access_token.token}
      EOS

      redirect_to settings_tokens_path, notice: notice
    else
      render :new
    end
  end

  # PATCH/PUT /settings/tokens/1
  def update
    if @access_token.update(access_token_params)
      notice = 'Token was successfully updated.'
      redirect_to settings_tokens_path, notice: notice
    else
      render :edit
    end
  end

  # DELETE /settings/tokens/1
  def destroy
    @access_token.revoke
    redirect_to settings_tokens_path, notice: 'Token was successfully destroyed.'
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def access_token_params
    params.require(:personal_access_token).permit(:note, scopes: []).tap do |access_token_params|
      scope_str = access_token_params.fetch(:scopes, []).join("\s")
      access_token_params[:scopes] = scope_str
    end
  end

  def personal_access_tokens
    current_user.personal_access_tokens.where(revoked_at: nil)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_access_token
    @access_token = current_user.personal_access_tokens.find(params[:id])
  end
end
