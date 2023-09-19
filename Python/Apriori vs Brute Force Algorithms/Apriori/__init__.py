from data import db1, db2, db3, db4, db5
from timeit import default_timer

start = default_timer()


def support(itemset, db):
    """
 Scans database to find support level of an itemset. Returns tuple of absolute support and relative support

 :param itemset:a set of itemset
 :param db:dictionary database of transactions
 :return:tuple of support count and support level
 """
    count = 0
    total_trans = len(db)
    for transaction in db.values():
        if itemset <= transaction:
            count += 1
        # itemset is subset of transaction, increment count
    return count, count / total_trans


def is_frequent(itemset, db, min_supp=.1):
    """
 Uses support() function to check if itemset meets user-specified minimum support level.

 :param itemset:set of itemset
 :param db:dictionary database of transactions
 :param min_supp:minimum support
 :return:boolean variable
 """
    itemset_support = support(itemset, db)
    return itemset_support[1] >= min_supp



def confidence(left_itemset, right_itemset, db):
    """
 Calculates confidence level.

 :param left_itemset:left of association rule arrow
 :param right_itemset:right of association rule arrow
 :param db:dictionary database of transactions
 :return:confidence level
 """
    denom = support(left_itemset, db)
    numer = support(right_itemset.union(left_itemset), db)[1]
    return numer / denom[1]



def is_confident(left_itemset, right_itemset, db, min_conf=.5):
    """
 Uses confidence() function to check if rule meets a user-specified minimum confidence level.

 :param left_itemset:left of association rule arrow
 :param right_itemset:right of association rule arrow
 :param db:dictionary database of transactions
 :param min_conf:minimum confidence level
 :return:boolean value
 """
    itemset_confidence = confidence(left_itemset, right_itemset, db)
    return itemset_confidence >= min_conf


def join(itemset_list):
    """
 Finds all possible k-itemsets from
 list of (k-1)-itemsets.

 :param itemset_list: list of (k-1)-itemsets
 :return: list of k-itemsets
 """
    joined_list = []
    for i in itemset_list:
        for j in itemset_list:
            if len(i ^ j) == 2:
                if i | j not in joined_list:
                    joined_list.append(i | j)
    return joined_list



def prune(candidate_list, db, min_supp=.1):
    """
    Prunes a candidate last and returns only itemsets
    that meet a specified minimum support level.

    :param candidate_list: list of joined itemset tuples
    :param db: dictionary database of transactions
    :return: list of frequent itemset tuples
    """
    pruned_list = []
    for i in candidate_list:
        if is_frequent(set(i), db, min_supp=.1):
            pruned_list.append(i)
    return sorted(pruned_list)


def print_possible_k_itemsets(k, candidate_itemsets):
    """
 Prints lengths of candidate k-itemsets. Does not print whole itemset as would be too cumbersome

 :param k:size of itemset
 :param candidate_itemsets:
 :return:size of list of itemsets for k-size itemset
 """
    # print(f"\n\nPossible {k}-itemsets:\n", candidate_itemsets, len(candidate_itemsets))
    print("\n\nLength of", k, ": ", len(candidate_itemsets))

def apriori(db, min_supp=.1, min_conf=.5):
    """
    Generates frequent k-itemsets starting with 1-itemsets.
    The while loop stops when no more frequent k-itemsets
    can be generated.

    :param db: dictionary database of transactions
    :param supp_count: set support count, default 2
    :return: list of lists of tuples, where inner lists represent
    frequent 1-itemsets, 2-itemsets,...to k-itemsets. Each
    innermost tuple represents one frequent itemset.
    """
    frequent_itemsets = []
    total_frequent_itemsets = []
    for transaction in db.values():
        for i, j in enumerate(transaction):
            if is_frequent({j},db,min_supp):
                if {j} not in frequent_itemsets:
                    frequent_itemsets.append({j})
    q = len(frequent_itemsets)
    while q > 0:
        total_frequent_itemsets.extend(frequent_itemsets)
        candidate_itemsets = join(frequent_itemsets)
        frequent_itemsets = prune(candidate_itemsets, db, min_supp)
        q = len(frequent_itemsets)
    print("\nFrequent Itemsets:\n",total_frequent_itemsets)


    print("\nAssociation Rules:")

    for itemset in total_frequent_itemsets:
        if len(itemset) <= 1:
            continue
        for i in itemset:
            left = {i}
            right = itemset - left
            if len(right) == 0:
                break
            print(f"{left}-->{right}[{support(itemset,db)[1]},{confidence(left,right,db)} has {is_confident(left,right,db,min_conf)} confidence]")
            # print(f"{right}-->{left}[{support(itemset,db)[1]},{confidence(right,left,db)} has {is_confident(right,left,db,min_conf)} confidence]")

    return total_frequent_itemsets, len(total_frequent_itemsets)



# print("\n\n\n\nAPRIORI for db1:\n\n", apriori(db1,min_supp=.1,min_conf=.5))
# print("\n\n\n\nAPRIORI for db2:\n\n", apriori(db2,min_supp=.2,min_conf=.3))
# print("\n\n\n\nAPRIORI for db3\n\n", apriori(db3,min_supp=.12,min_conf=.2))
# print("\n\n\n\nAPRIORI for db4\n\n", apriori(db4, min_supp=.15,min_conf=.5))

print("\n\n\n\nAPRIORI for db5\n\n", apriori(db5,min_supp=.1,min_conf=.3))



time = default_timer() - start
print(time, "seconds,\n", time / 60, "minutes")
