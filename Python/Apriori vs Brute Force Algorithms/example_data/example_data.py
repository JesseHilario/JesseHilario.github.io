import random

"""
This file creates a list of the most commonly purchased
Amazon items and, using the random module, randomly
generates transactional databases using the make_db(function).
"""


items= \
    ["instant pot",
     "Brita water filter",
     "makeup remover",
     "crocs",
     "Macbook",
     "USB splitter",
     "self-help books",
     "pullover hoodies",
     "long sleeve blouse",
     "yoga pants",
     "ice maker",
     "CeraVe moisturizing cream",
     "carpet spot remover",
     "hand soap",
     "Ring video doorbell",
     "crew t-shirts",
     "socks",
     "boxer briefs",
     "kids' books",
     "Amazon Fire tablet",
     "nitrile gloves",
     "disposable face masks",
     "digital bathroom scale",
     "antigen rapid test",
     "bed sheet set",
     "no show thongs",
     "refrigerator",
     "electric stove top",
     "air purifier",
     "throw pillows"
     ]

def make_db(seed=1, n_trans=20):
    """
    Create a transactional database using above list
    of items with between 1 and 5 items per transaction.

    :param seed: sets seed, default = 1
    :param n_trans: number of transactions in database
    :return: a dictionary with transaction numbers as keys
    and sets of chosen items as values
    """
    random.seed(seed)
    db = {}
    for i in range(n_trans):
        trans = random.choices(items, k=random.randint(1,5))
        db[i + 1] = set(trans)
    return db


"""
make_db() function is used to make 5 different databases with seeds
set from 1 to 5
"""

db1 = make_db(1)
db2 = make_db(2)
db3 = make_db(3)
db4 = make_db(4)
db5 = make_db(5)

print(f"Database 1: \n{db1}\n\nDatabase 2: \n{db2}\n\nDatabase 3:\n{db3}\n\nDatabase 4:\n{db4}\n\nDatabase 5:\n{db5}")
