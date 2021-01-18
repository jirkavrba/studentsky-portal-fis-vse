# frozen_string_literal: true

class DiscordServersController < ApplicationController
  before_action :set_discord_server, only: %i[show edit update destroy]
  before_action :require_admin_privileges!

  # GET /discord_servers
  # GET /discord_servers.json
  def index
    @discord_servers = DiscordServer.all
  end

  # GET /discord_servers/1
  # GET /discord_servers/1.json
  def show; end

  # GET /discord_servers/new
  def new
    @discord_server = DiscordServer.new
  end

  # GET /discord_servers/1/edit
  def edit; end

  # POST /discord_servers
  # POST /discord_servers.json
  def create
    @discord_server = DiscordServer.new(discord_server_params)

    respond_to do |format|
      if @discord_server.save
        format.html { redirect_to @discord_server, notice: 'Discord server was successfully created.' }
        format.json { render :show, status: :created, location: @discord_server }
      else
        format.html { render :new }
        format.json { render json: @discord_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /discord_servers/1
  # PATCH/PUT /discord_servers/1.json
  def update
    respond_to do |format|
      if @discord_server.update(discord_server_params)
        format.html { redirect_to @discord_server, notice: 'Discord server was successfully updated.' }
        format.json { render :show, status: :ok, location: @discord_server }
      else
        format.html { render :edit }
        format.json { render json: @discord_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discord_servers/1
  # DELETE /discord_servers/1.json
  def destroy
    @discord_server.destroy
    respond_to do |format|
      format.html { redirect_to discord_servers_url, notice: 'Discord server was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_discord_server
    @discord_server = DiscordServer.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def discord_server_params
    params.require(:discord_server).permit(:embed_url, :priority)
  end
end
