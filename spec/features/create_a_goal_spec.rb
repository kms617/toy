require 'rails_helper'

feature 'user submits a new goal' do

  scenario 'user submits a complete form' do
    # User Story: I can submit a new goal, which must contain: the time I expect to
    # complete it in,the focus of the goal and whether or not I completed
    # it. I may optionally submit an objective for the goal.

    goal = FactoryGirl.create(:goal)

    visit 'goals/new'

    fill_in "Goal", with: goal.goal
    choose 'goal_completed_false'
    fill_in "Duration", with: goal.duration
    fill_in "Objective", with: goal.objective
    click_button "Create Goal"

    expect(page).to have_content("Your goal has successfully been set!")
    expect(page).to have_content(goal.goal)
    expect(page).to have_content(goal.duration)
    expect(page).to have_content(goal.objective)

  end

  scenario 'user submits an incomplete form' do
    # User Story: 1a. If I fail to submit a complete form
    # I want to receive an error message prompting me
    # to provide the correct information and alerting me to my errors.

    visit 'goals/new'

    click_button "Create Goal"

    expect(page).to have_content("There was a problem, please try again.")
    expect(page).to have_content("Goal can't be blank")
    expect(page).to have_content("Duration can't be blank")
    expect(page).to have_content("Duration is not a number")
    expect(page).to have_content("Completed is not included in the list")

  end

  scenario 'user submits a form with errors' do
    # User Story: 1b. If there are errors in my form,
    # I want to receive an error message detailing my
    # mistakes so that I can correct them.'

    goal = FactoryGirl.create(:goal)

    visit 'goals/new'

    fill_in "Goal", with: "As late as the 1960s many people perceived computer
                        programming as a natural career choice for savvy young women. Even the
                        trend-spotters at Cosmopolitan Magazine urged their fashionable female readership
                        to consider careers in programming."
    fill_in "Duration", with: "twenty"
    choose 'goal_completed_false'
    fill_in "Objective", with: "In an article titled “The Computer Girls,”
                                the magazine described the field as offering better job opportunities for women
                                than many other professional careers. As computer scientist Dr. Grace Hopper
                                told a reporter, programming was “just like planning a dinner. You have to plan
                                ahead and schedule everything so that it’s ready when you need it…. Women are
                                ‘naturals’ at computer programming.” James Adams, the director of education for
                                the Association for Computing Machinery, agreed: “I don’t know of any other field,
                                outside of teaching, where there’s as much opportunity for a woman.”"
    click_button "Create Goal"

    expect(page).to have_content("There was a problem, please try again.")
    expect(page).to have_content("Goal is too long")
    expect(page).to have_content("Objective is too long")
    expect(page).to have_content("Duration is not a number")
  end
end
