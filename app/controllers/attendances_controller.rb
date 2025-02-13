class AttendancesController < ApplicationController
  before_action :set_user, only: [:new, :create, :mark_attendance]

  def new
    @attendance = @user.attendances.build
  end

  def create
    @attendance = @user.attendances.build(attendance_params)
    if @attendance.save
      redirect_to user_attendances_path(@user), notice: "出席情報が登録されました。"
    else
      render :new
    end
  end

  def index
    @attendances = @user.attendances
  end

  # 日にち別で出席情報を表示するアクション
  def by_date
    @classname = User.select(:classname).distinct
    @date = params[:date]
    # Includes :user to avoid missing User association error
    @attendances = Attendance.includes(:user).where(date: @date)
  end

  # クラス別で出席情報を表示するアクション
  def by_class
    # クラス名でユーザーを取得
    @classname = params[:classname]
    @users = User.where(classname: @classname)

    # 該当クラスの全ユーザーの出席データを取得
    @attendances = Attendance.where(user: @users).order(:date)

    # 必要に応じてページをレンダリング
    render :by_class
  end

  def new_by_class
    @classname = params[:classname]
    @users = User.where(classname: @classname)
  end

  # attendances_controller.rb
  def mark_attendance
    @user = User.find(params[:user_id])
    
    # 既にその日に出席登録がされているかを確認
    if @user.attendances.exists?(date: Date.today)
      redirect_to attendances_by_class_path(@user.classname), alert: '本日はすでに出席登録がされています'
      return
    end

    # 出席情報を新たに作成
    @attendance = @user.attendances.create(date: Date.today, status: '出席')

    if @attendance.save
      redirect_to attendances_by_class_path(@user.classname), notice: '出席が登録されました'
    else
      redirect_to users_home_path, alert: '出席登録に失敗しました'
    end
  end

  def destroy
    @attendance = Attendance.find(params[:id])
  
    if @attendance.destroy
      redirect_to attendances_by_class_path(@attendance.user.classname), notice: '出席情報が削除されました'
    else
      redirect_to attendances_by_class_path(@attendance.user.classname), alert: '出席情報の削除に失敗しました'
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def attendance_params
    params.require(:attendance).permit(:date, :status)
  end
end