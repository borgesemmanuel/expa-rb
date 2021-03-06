require 'test_helper'

class PeoplesTest < Minitest::Test
  def setup
    if EXPA.client.nil?
      @expa = EXPA.setup()
      @expa.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])
    else
      @expa = EXPA.client
    end
  end

  def test_list_by_param
    params = {}

    result = EXPA::People.list_by_param
    assert(result, 'No result')

    items_to_retrieve = 5
    params['per_page'] = items_to_retrieve
    result = EXPA::People.list_by_param(params)
    assert(result, 'No result')
    assert(result.is_a?(Array), 'Wrong type returned')
    assert(result.first.is_a?(Person), 'Wront type returned')
    assert(result.count == items_to_retrieve, ' No result or wrong result. Expected ' + items_to_retrieve.to_s + ' and got ' + result.count.to_s)

    items_to_retrieve = 50
    params['per_page'] = items_to_retrieve
    result = EXPA::People.list_by_param(params)
    assert(result, 'No result')
    assert(result.is_a?(Array), 'Wrong type returned')
    assert(result[0].is_a?(Person), 'Wront type returned')
    assert(result.count == items_to_retrieve, ' No result or wrong result. Expected ' + items_to_retrieve.to_s + ' and got ' + result.count.to_s)
  end

  def test_find_attributes_by_id
    params = {}

    items_to_retrieve = 1
    params['per_page'] = items_to_retrieve
    params['filters[status]'] = 'matched'
    person_to_compare = EXPA::People.list_by_param(params).first

    person_real = EXPA::People.get_attributes(person_to_compare.id)
    assert(person_real, ' No result')
    assert(person_real.is_a?(Person), 'Wrong type returned')
    assert(person_real.id == person_to_compare.id, 'It is not the same register')
  end

  def test_list_applications_by_id
    params = {}

    items_to_retrieve = 1
    params['per_page'] = items_to_retrieve
    params['filters[status]'] = 'in progress'
    person = EXPA::People.list_by_param(params).first

    applications = EXPA::People.list_applications_by_id(person.id)
    assert(applications, ' No result')
    assert(applications.is_a?(Array), ' Wront type returned')
    assert(applications.first.is_a?(Application), 'Wrong type returned')

    items_to_retrieve = 1
    params['per_page'] = items_to_retrieve
    params['filters[status]'] = 'matched'
    person = EXPA::People.list_by_param(params).first

    applications = EXPA::People.list_applications_by_id(person.id)
    assert(applications, ' No result')
    assert(applications.is_a?(Array), ' Wront type returned')
    assert(applications.first.is_a?(Application), 'Wrong type returned')

    items_to_retrieve = 1
    params['per_page'] = items_to_retrieve
    params['filters[status]'] = 'realized'
    person = EXPA::People.list_by_param(params).first

    applications = EXPA::People.list_applications_by_id(person.id)
    assert(applications, ' No result')
    assert(applications.is_a?(Array), ' Wront type returned')
    assert(applications.first.is_a?(Application), 'Wrong type returned')

    items_to_retrieve = 1
    params['per_page'] = items_to_retrieve
    params['filters[status]'] = 'completed'
    person = EXPA::People.list_by_param(params).first

    applications = EXPA::People.list_applications_by_id(person.id)
    assert(applications, ' No result')
    assert(applications.is_a?(Array), ' Wront type returned')
    assert(applications.first.is_a?(Application), 'Wrong type returned')
  end

  def test_total_item
    total = EXPA::People.total_items
    assert(total.is_a?(Integer), 'Total of item is not a number or is not working')
  end

  def test_total_applications
    params = {}

    items_to_retrieve = 1
    params['per_page'] = items_to_retrieve
    params['filters[status]'] = 'in progress'
    person = EXPA::People.list_by_param(params)[0]

    total = EXPA::People.total_applications_from_person(person.id)
    assert(total.is_a?(Integer), 'Total of item is not a number or is not working')
    assert(total > 0, 'There is zero applications')

    items_to_retrieve = 1
    params['per_page'] = items_to_retrieve
    params['filters[status]'] = 'matched'
    person = EXPA::People.list_by_param(params)[0]

    total = EXPA::People.total_applications_from_person(person.id)
    assert(total.is_a?(Integer), 'Total of item is not a number or is not working')
    assert(total > 0, 'There is zero applications')

    items_to_retrieve = 1
    params['per_page'] = items_to_retrieve
    params['filters[status]'] = 'realized'
    person = EXPA::People.list_by_param(params)[0]

    total = EXPA::People.total_applications_from_person(person.id)
    assert(total.is_a?(Integer), 'Total of item is not a number or is not working')
    assert(total > 0, 'There is zero applications')

    items_to_retrieve = 1
    params['per_page'] = items_to_retrieve
    params['filters[status]'] = 'completed'
    person = EXPA::People.list_by_param(params)[0]

    total = EXPA::People.total_applications_from_person(person.id)
    assert(total.is_a?(Integer), 'Total of item is not a number or is not working')
    assert(total > 0, 'There is zero applications')
  end

  def test_list_application_created_at
    time_minus_five = Time.now - 5*60
    time_minus_ten = Time.now - 10*60
    time_minuts_twenty = Time.new - 20*60

    people_five = EXPA::People.list_everyone_created_after(time_minus_five)

    people_five.each do |person|
      assert(person.created_at >= time_minus_five, 'A register is older than ' + time_minus_five.to_s + '. It is ' + person.created_at.to_s)
    end

    people_ten = EXPA::People.list_everyone_created_after(time_minus_ten)

    people_ten.each do |person|
      assert(person.created_at >= time_minus_ten, 'A register is older than ' + time_minus_ten.to_s + '. It is ' + person.created_at.to_s)
    end

    people_twenty = EXPA::People.list_everyone_created_after(time_minuts_twenty)

    people_twenty.each do |person|
      assert(person.created_at >= time_minuts_twenty, 'A register is older than ' + time_minuts_twenty.to_s + '. It is ' + person.created_at.to_s)
    end

    assert(people_twenty.count >= people_ten.count, 'We have more younger registers (' + people_ten.count.to_s + ') than old ones(' + people_twenty.count.to_s + ')')
    assert(people_ten.count >= people_five.count, 'We have more younger registers (' + people_five.count.to_s + ') than old ones(' + people_ten.count.to_s + ')')
    assert(people_twenty.count >= people_five.count, 'We have more younger registers (' + people_five.count.to_s + ') than old ones(' + people_twenty.count.to_s + ')')

    params = {'filters[status]' => 'in progress'}

    people_five_in_progress = EXPA::People.list_everyone_created_after(time_minus_five, params)

    people_five_in_progress.each do |person|
      assert(person.created_at >= time_minus_five, 'A register is older than ' + time_minus_five.to_s + '. It is ' + person.created_at.to_s)
    end

    people_ten_in_progress = EXPA::People.list_everyone_created_after(time_minus_ten, params)

    people_ten_in_progress.each do |person|
      assert(person.created_at >= time_minus_ten, 'A register is older than ' + time_minus_ten.to_s + '. It is ' + person.created_at.to_s)
    end

    people_twenty_in_progress = EXPA::People.list_everyone_created_after(time_minuts_twenty, params)

    people_twenty_in_progress.each do |person|
      assert(person.created_at >= time_minuts_twenty, 'A register is older than ' + time_minuts_twenty.to_s + '. It is ' + person.created_at.to_s)
    end

    assert(people_five.first.id != people_five_in_progress.first.id, 'The list_all bought the same data for the general one (id=' + people_five.first.id.to_s + ') and in_progress one (id=' + people_five_in_progress.first.id.to_s + ')') unless people_five.empty? || people_five_in_progress.empty?
    assert(people_ten.first.id != people_ten_in_progress.first.id, 'The list_all bought the same data for the general one (id=' + people_ten.first.id.to_s + ') and in_progress one (id=' + people_ten_in_progress.first.id.to_s + ')') unless people_ten.empty? || people_ten_in_progress.empty?
    assert(people_twenty.first.id != people_twenty_in_progress.first.id, 'The list_all bought the same data for the general one (id=' + people_twenty.first.id.to_s + ') and in_progress one (id=' + people_twenty_in_progress.first.id.to_s + ')') unless people_twenty.empty? || people_twenty_in_progress.empty?
    assert(people_twenty_in_progress.count >= people_ten_in_progress.count, 'We have more younger registers (' + people_ten_in_progress.count.to_s + ') than old ones(' + people_twenty_in_progress.count.to_s + ')')
    assert(people_ten_in_progress.count >= people_five_in_progress.count, 'We have more younger registers (' + people_five_in_progress.count.to_s + ') than old ones(' + people_ten_in_progress.count.to_s + ')')
    assert(people_twenty_in_progress.count >= people_five_in_progress.count, 'We have more younger registers (' + people_five_in_progress.count.to_s + ') than old ones(' + people_twenty_in_progress.count.to_s + ')')
  end

end