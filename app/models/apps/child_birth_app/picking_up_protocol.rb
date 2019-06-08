module Apps
  module ChildBirthApp
    class PickingUpProtocol
      def self.ask_or_answer(mother_civil_state, born_before_300_days)
        allowed_civil_state = [:married, :single, :divorced, :widow]
        allowed_born_before_300_days = [:yes, :no]

        has_answer = allowed_born_before_300_days.include?(born_before_300_days)

        if allowed_civil_state.include?(mother_civil_state)
          if [:married, :single].include?(mother_civil_state)
            :answer
          elsif [:divorced, :widow].include?(mother_civil_state) && has_answer
            :answer
          elsif mother_civil_state == :divorced
            :ask_divorce
          elsif mother_civil_state == :widow
            :ask_widow
          end
        else
          :ask_mother_civil_state
        end
      end
    end
  end
end
