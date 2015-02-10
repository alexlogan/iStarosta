# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.delete_all
Lesson.delete_all
Student.delete_all

user = User.create(
  :email => '777alexlogan@gmail.com',
  :name => 'Alex Morg',
  :password => '123456',
  :role => 'admin',
  :group_attributes => {
    :name => 'ВБИС32'
  }
)

Lesson.create(:group_id => 1, :name => 'Базы данных')
Lesson.create(:group_id => 1, :name => 'Информационные технологии')
Lesson.create(:group_id => 1, :name => 'ООП')

10.times Student.create(:group_id => 1, :name => Faker::Name.name)

user = User.create(
  :email => '7777alexlogan@gmail.com',
  :name => 'Alex',
  :password => '123456',
  :role => '',
  :group_attributes => {
    :name => 'ВБИС322'
  }
)

Lesson.create(:group_id => 2, :name => 'Базы данных')
Lesson.create(:group_id => 2, :name => 'Информационные технологии')
Lesson.create(:group_id => 2, :name => 'ООП')

10.times Student.create(:group_id => 2, :name => Faker::Name.name)
