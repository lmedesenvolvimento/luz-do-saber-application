json.partial! 'game/themes/theme', modulo: @modulo, theme: @theme

json.units do
  json.array! @units do |unit|
    json.partial! 'unit', modulo: @modulo, theme: @theme, unit: unit

    questions = if params[:group_code].present?
                  policy_scope(unit.questions.by_group(params[:group_code]))
                else
                  policy_scope(unit.questions.joins(:user).where(users: { role: User.roles['admin'] }))
                end.order(:order)

    json.questions questions do |question|
      json.partial! 'game/questions/info', q: question
    end
  end
end
