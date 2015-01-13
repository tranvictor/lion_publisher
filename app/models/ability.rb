class Ability
  include CanCan::Ability

  def initialize(user)
    user = user || User.new

    # Article
    cannot :new, Article
    can :index, Article
    can :show, Article do |a|
      a.published?
    end

    # Message
    cannot [:index, :show, :reply, :destroy], Message
    can [:new, :create], Message

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
