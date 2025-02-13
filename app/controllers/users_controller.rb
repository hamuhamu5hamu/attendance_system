# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def index
    @user = User.all
    # @classname = User.select(:classname).distinct
    @classname = User.distinct.pluck(:classname)
    @classes = User.select(:classname).distinct # クラス名を一意に取得
    @students_by_class = @classes.each_with_object({}) do |classname, hash|
      hash[classname.classname] = User.where(classname: classname.classname)
    end
    # 現在の日付に出席していないユーザーを取得
    today = Date.today

    @absent_students = User.joins(:attendances)
    .where.not(attendances: { date: Date.today })
    .distinct
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      redirect_to action: "index"
    else
      redirect_to action: "new"
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      redirect_to action: "show", id: user.id
    else
      redirect_to action: "new"
    end
  end

  def home
    @user = User.all
    # @classname = User.select(:classname).distinct
    @classname = User.distinct.pluck(:classname)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to action: :index
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :classname)
  end
end
