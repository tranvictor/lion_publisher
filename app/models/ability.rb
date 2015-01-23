class Ability
  include CanCan::Ability

  def initialize(user)
    user = user || User.new

    # Article
    can [:index, :random], Article
    can :show, Article, :published => true
    cannot [:new, :edit, :create, :update, :destroy, :clearcache], Article

    # Message
    cannot [:index, :show, :reply, :destroy], Message
    can [:new, :create], Message

    # User
    can [:edit, :update], User, :id => user.id

    if user.writer?
      # a writer could only manage his/her articles
    	can :manage, Article, :user_id => user.id
    	cannot :destroy, Article
    end

    if user.admin?
    	can :manage, :all
    end
  end
end
