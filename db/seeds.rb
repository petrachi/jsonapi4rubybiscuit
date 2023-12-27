# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

publisher_1 = Publisher.create(name: "Éditions Dupuis", client_id: :dupuis)
author_1 = Author.create(name: "Rob-Vel", description: "Rob-Vel,Rob-Vel, de son vrai nom Robert Pierre Velter, né le 9 février 1909 et mort le 27 avril 1991, est célèbre pour être le créateur du personnage de Spirou.")
author_2 = Author.create(name: "Franquin", description: "André Franquin, né le 3 janvier 1924 à Etterbeek et mort le 5 janvier 1997 à Saint-Laurent-du-Var, est un auteur belge francophone de bande dessinée")
book_1 = Book.create(name: "Les aventures de Spirou", publisher: publisher_1, author: author_1, price: 1200)
book_2 = Book.create(name: "Gaston Lagaffe, Tome 1", publisher: publisher_1, author: author_2, price: 1100)
book_3 = Book.create(name: "Attention Lagaffe !, Tome 2", publisher: publisher_1, author: author_2, price: 1100)

publisher_2 = Publisher.create(name: "Éditions Hatier", client_id: :hatier)
author_3 = Author.create(name: "Louis-Nicolas Bescherelle", description: "A l'origine, Louis-Nicolas Bescherelle, un lexicographe et grammairien français, créa avec son frère Henri l'ancêtre du « Bescherelle » en 1842 « Le Dictionnaire des huit mille verbes usuels de la langue française. »")
book_4 = Book.create(name: "Le Bescherelle", publisher: publisher_2, author: author_3, price: 1950)
