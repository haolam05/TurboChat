# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

hao = User.create(  name: "Lâm Tường Hào",
                    email: 'tuonghao2001@gmail.com',
                    password: '1q2w3e',
                    password_confirmation: '1q2w3e',
                    role: 'admin'
                )
User.create(       name: "林祥好",
                email: 'lamtuonghao2001@gmail.com',
                password: '1q2w3e',
                password_confirmation: '1q2w3e'
            )
User.create(    name: "Tường Hào",
                email: 'tuonghao@gmail.com',
                password: '1q2w3e',
                password_confirmation: '1q2w3e'
            )
hao.joined_rooms << Room.create(name: 'General', is_private: false)
hao.joined_rooms << Room.create(name: 'Testing', is_private: false)