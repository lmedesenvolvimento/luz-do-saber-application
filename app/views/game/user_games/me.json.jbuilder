json.extract! @student, :first_name,
                        :last_name,
                        :birthdate,
                        :city,
                        :school_group_code,
                        :school_name,
                        :school_period,
                        :school_student_code,
                        :school_year,
                        :state

json.group do
  json.extract! @group, :code, :description, :name
end
