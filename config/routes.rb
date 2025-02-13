Rails.application.routes.draw do
  # 基本ページ
  root to: "users#index"
  get "users/index", to: "users#index"
  get "users/home", to: "users#home"

  get "users/home", to: "users#home"

  # 日にち別で出席を確認するページ
  get "attendances/date/:date", to: "attendances#by_date", as: "attendances_by_date"

  # クラス別で出席を確認するページ
  get "attendances/class/:classname", to: "attendances#by_class", as: "attendances_by_class"

  # 出席削除用のルートを追加
  resources :attendances, only: [ :destroy ]

    # ユーザー関連
    resources :users do
      resources :attendances, only: [ :index, :create, :destroy ] do
        # クラス別出席確認、新規クラス登録のページ
        collection do
          get "new_by_class/:classname", to: "attendances#new_by_class", as: "new_by_class"
          post "mark_attendance", to: "attendances#mark_attendance"
        end
        # 出席登録削除用ルート
        delete "delete_attendance/:id", to: "attendances#destroy", as: "delete_attendance"
      end
    end
end
