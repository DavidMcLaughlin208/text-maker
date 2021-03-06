class PlayersController < ApplicationController

  def new
    @team = Team.find_by(id: params[:team_id])
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    if @player.save
      Roster.create(team_id: params[:player][:team_ids], player: @player)
      redirect_to @player, notice: 'Player was successfully created.'
    else
      render :new, errors: @player.errors.full_messages.join(", ")
    end
  end

  def show
    @player = Player.find_by(id: params[:id])
  end

  def edit
    @player = Player.find_by(id: params[:id])
  end

  def update
    @player = Player.find_by(id: params[:id])
    if @player.update(player_params)
      redirect_to @player
    else
      render :edit
    end
  end

  def decline
    @game = Game.find_by(id: params[:game_id])
    @confirmation = Confirmation.find_or_initialize_by(player_id: params[:player_id], game_id: params[:game_id])
    @confirmation.confirmed = false
    @confirmation.save!

    redirect_to team_game_path(@game.team, @game)
  end

  def confirm
    @game = Game.find_by(id: params[:game_id])
    if @game.full?
      redirect_to team_game_path(@game.team, @game), notice: "Game is already full."
    else
      @confirmation = Confirmation.find_or_initialize_by(player_id: params[:player_id], game_id: params[:game_id])
      @confirmation.confirmed = true
      @confirmation.save

      redirect_to team_game_path(@game.team, @game)
    end
  end

  def remove
    @team = Team.find_by(id: params[:team_id])
    @roster = Roster.find_by(team_id: params[:team_id], player_id: params[:id])
    @roster.destroy
    redirect_to @team
  end

  private

  def player_params
    params.require(:player).permit(:name, :phone_number)
  end

end
