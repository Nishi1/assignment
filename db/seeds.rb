if UserType.count == 0
  UserType.create([{id: 1, name: "CEO"},{id: 2, name: "VP"},{id: 3, name: "Director"},{id: 4, name: "Manager"},{id: 5, name: "SDE"}])
end