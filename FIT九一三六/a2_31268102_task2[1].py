# Header
# Student name: Shihan Zhang
# Student ID: 31268102
# start date: 2020-05-26
# last modified date:  2020-06-07

from a2_31268102_task1 import *
import random


class Patient(Person):
    def __init__(self, first_name, last_name, health):
        # get data from Person
        Person.__init__(self, first_name, last_name)
        # add healthPoints attribute
        self.healthPoints = health

    # get health points
    def get_health(self):
        return self.healthPoints

    # set the new health point after calculate
    def set_health(self, new_health):
        self.healthPoints = new_health

    # set boolean value for check health state
    def is_contagious(self):
        lean_health_points = round(self.healthPoints)
        # initial health is less than or equal to 49, this person is contagious
        if lean_health_points <= 49:
            return True
        else:
            return False

    # check the infect status
    def infect(self, viral_load):
        # if equal or less than 29 or = 0.
        if 0 <= self.healthPoints <= 29:
            new_points = self.healthPoints - (0.1 * viral_load)
        # if greater than 29 and less than 50.
        elif 50 > self.healthPoints > 29:
            new_points = self.healthPoints - (1.0 * viral_load)
        # if equal or greater than 50.
        elif self.healthPoints >= 50:
            new_points = self.healthPoints - (2.0 * viral_load)
        # adjust the new health point if less than 0. set it to 0.
        if new_points <= 0:
            self.healthPoints = 0
        # set health points = new health point value
        else:
            self.healthPoints = new_points

    def sleep(self):
        # add 5 health point when sleeping.
        self.healthPoints += 5
        # adjust the health point to 100 when overload happen.
        if self.healthPoints > 100:
            self.healthPoints = 100

    def viral_load(self):
        # according to the formula sheet
        # calculate the viral_load
        viral_load = 5 + pow((self.healthPoints - 25), 2) / 62.0
        return viral_load


def meetingInfect(self_as_patient, friend_as_patient):
    # check if myself is contagious
    # set status for self
    self_contagious = self_as_patient.is_contagious()
    # set status for friend
    friend_is_contagious = friend_as_patient.is_contagious()
    # set viral load for myself
    self_viral_load = self_as_patient.viral_load()
    # set viral load for friends
    friend_viral_load = friend_as_patient.viral_load()
    # print(self_viral_load, friend_viral_load)

    # when myself is contagious
    if self_contagious:
        # visit friends and infect him
        # update friend's health point
        friend_as_patient.infect(self_viral_load)

    # when friend is contagious
    if friend_is_contagious and not self_contagious:
        # visit me and infect me
        # update myself's health point
        self_as_patient.infect(friend_viral_load)


def run_simulation(days, meeting_probability, patient_zero_health):
    # load patients and set initial health value of 75
    patient_list = load_patients(75)
    # set patient_zero
    patient_zero = patient_list[0]
    # set health point for patient_zero
    patient_zero.set_health(patient_zero_health)
    # init the result list
    result = []
    # looping the days for simulation
    for day in range(days):
        # temporary value for contagious amount
        temp_contagious_num = 0
        # looping patients
        for patient in patient_list:
            # assign new list for store patient's friends
            patient_friends_list = patient.get_friends()
            # looping the list
            for friend in patient_friends_list:
                # random.random() get value from between [0,1)
                will_meet = random.random()
                # if probability is 0 , do nothing and go to next person
                if meeting_probability == 0:
                    continue
                # if probability is 1 , infect this friend.
                elif meeting_probability == 1:
                    meetingInfect(patient, friend)
                    continue
                # if will_meet smaller or equal to meeting_probability
                # (core random value for each simulation)
                # patient will meet friend
                elif will_meet <= meeting_probability:
                    meetingInfect(patient, friend)

        # init final day HP as list
        final_day_end_health = []
        # looping patients
        for patient in patient_list:
            # add up the contagious amount, if is contagious
            if patient.is_contagious():
                temp_contagious_num += 1
            # add the patient health data to list
            final_day_end_health.append(round(patient.get_health()))
            # sleep to recover points at end of day.
            patient.sleep()
        # order the result, low to high
        final_day_end_health.sort()
        # add the counting to result list.
        result.append(temp_contagious_num)
        #print(final_day_end_health)
        #print(temp_contagious_num)
    return result


def load_patients(default_health):
    # read file
    with open('./a2_sample_set.txt', 'r') as f:
        all_lines = f.readlines()
    # close file
    f.close()
    # assign person object as dictionary
    all_patient_object = {}
    # looping all lines(names and list)
    for line in all_lines:
        # get data for first person name and the list which returned from 'friendship'
        # 'friendship()' had been imported from task 1
        myself, my_friend_list = friendship(line)
        # statement for checking if myself in the dictionary
        # if myself(name as the key) not in the dictionary
        if myself not in all_patient_object.keys():
            # split the name
            first_name, last_name = myself.split(' ')
            # pass value to Person(class) and set the return value as the instance.
            myself_instance = Patient(first_name, last_name, default_health)
            # set the key to instance.
            all_patient_object[myself] = myself_instance
        else:
            # set the instance as the dict return value
            myself_instance = all_patient_object.get(myself)
        # looping the friends
        for friend in my_friend_list:
            # check if friend not in the dict
            if friend not in all_patient_object.keys():
                # split the name
                friend_first_name, friend_last_name = friend.split(' ')
                # pass to the Person
                friend_instance = Patient(friend_first_name, friend_last_name, default_health)
                # set the value
                all_patient_object[friend] = friend_instance
            else:
                # set the instance as the dict return value
                friend_instance = all_patient_object.get(friend)
            # call add_friend method to add friend
            myself_instance.add_friend(friend_instance)

    # assign a new list, looping the dictionary then set the result to new instance
    all_patient_instance: list = [patient for patient in all_patient_object.values()]
    return all_patient_instance


if __name__ == '__main__':
    test_result = run_simulation(40, 1, 1)
    print(test_result)

