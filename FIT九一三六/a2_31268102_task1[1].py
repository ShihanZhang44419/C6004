# Header
# Student name: Shihan Zhang
# Student ID: 31268102
# start date: 2020-05-26
# last modified date:  2020-06-07


class Person:
    # constructor for Person with first name, last name
    # init friends list
    def __init__(self, first_name, last_name):
        self.first_name = first_name
        self.last_name = last_name
        self.friends = []

    # define function to add friend
    def add_friend(self, friend_person):
        # append new friends to list
        # the length of the list will be the counts of each person's friend
        if friend_person not in self.friends:
            # add the new friend to friend list
            self.friends.append(friend_person)
        else:
            print(f'{friend_person} friend already in {self.get_name()}')

    # return Person's first name and last name(combined)
    def get_name(self):
        # combine First name and Last name together
        full_name: str = ' '.join([self.first_name, self.last_name])
        return full_name

    # return a list which represent Person's friend
    def get_friends(self):
        return self.friends

    # using __repr__ rather than __str__. because __str__ prints the object with address 'object at
    # <__main__.Person object at 0x000001E9DC79F1C8>'.
    def __repr__(self):
        # print all information with format.
        return '%s %s has %d friends' % (self.first_name, self.last_name, len(self.get_friends()))


# Function for split the input line form file
def friendship(line):
    myself, my_friend_text = line.split(':')
    # trim lines
    my_friend_list = [item.strip('\r\n').strip() for item in my_friend_text.split(',')]
    # return my name 'e.g. Gill Bates'
    # And the following friend as list e.g. ['Jom Tones', 'Verdie Tong', 'Ossie Digangi']
    return myself, my_friend_list


def addFriend(all_lines):
    # assign person object as dictionary
    all_person_object = {}
    # looping all lines(names and list)
    for line in all_lines:
        # get data for first person name and the list which returned from 'friendship'
        myself, my_friend_list = friendship(line)
        # print(myself, my_friend_list)
        # statement for checking if myself in the dictionary
        # if myself(name as the key) not in the dictionary
        if myself not in all_person_object.keys():
            # split the name
            first_name, last_name = myself.split(' ')
            # pass value to Person(class) and set the return value as the instance.
            myself_instance = Person(first_name, last_name)
            # set the key to instance.
            all_person_object[myself] = myself_instance
        else:
            # set the instance as the dict return value
            myself_instance = all_person_object.get(myself)
        # looping the friends
        for friend in my_friend_list:
            # check if friend not in the dict
            if friend not in all_person_object.keys():
                # split the name
                friend_first_name, friend_last_name = friend.split(' ')
                # pass to the Person
                friend_instance = Person(friend_first_name, friend_last_name)
                # set the value
                all_person_object[friend] = friend_instance
            else:
                # set the instance as the dict return value
                friend_instance = all_person_object.get(friend)
            # call add_friend method to adding friend
            myself_instance.add_friend(friend_instance)
    # return the dict
    return all_person_object


def load_people():
    # read file
    with open('./a2_sample_set.txt', 'r') as f:
        all_lines = f.readlines()
    # close file
    f.close()
    # assign the dictionary as the return value of addFriend()
    all_person_object = addFriend(all_lines)
    # assign a new list, looping the dictionary then set the result to new instance
    all_person_instance: list = [person for person in all_person_object.values()]
    # print(all_person_instance)
    return all_person_instance


# run main function
if __name__ == '__main__':
    result = load_people()
    # print(result)
    # print(len(result))
