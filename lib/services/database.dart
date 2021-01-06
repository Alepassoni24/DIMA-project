import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/model/review_obj.dart';
import 'package:dima_project/model/user_obj.dart';

class DatabaseService {
  //unique id of the current user
  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');
  final CollectionReference recipeCollection =
      FirebaseFirestore.instance.collection('recipe');

  Future updateUserData(String username, String profilePhotoURL) async {
    return await userCollection.doc(uid).update({
      'username': username,
      'profilePhotoURL': profilePhotoURL,
    });
  }

  Future insertUserData(
      String username,
      int recipeNum,
      double rating,
      int reviewNum,
      String profilePhotoURL,
      bool userRegisteredWithMail) async {
    return await userCollection.doc(uid).set({
      'username': username,
      'recipeNumber': recipeNum,
      'rating': rating,
      'reviewNumber': reviewNum,
      'profilePhotoURL': profilePhotoURL,
      'userRegisteredWithMail': userRegisteredWithMail,
    });
  }

  //get user stream if needed
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  //get user data from snapshot
  UserData userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.id,
      username: snapshot.get('username'),
      recipeNumber: snapshot.get('recipeNumber'),
      rating: snapshot.get('rating').toDouble(),
      reviewNumber: snapshot.get('reviewNumber'),
      profilePhotoURL: snapshot.get('profilePhotoURL'),
      userRegisteredWithMail: snapshot.get('userRegisteredWithMail'),
    );
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(userDataFromSnapshot);
  }

  //get user stream from a user id
  Stream<DocumentSnapshot> getUser(String userId) {
    return userCollection.doc(userId).snapshots();
  }

  // Update a user recipeNumber when a new recipe is inserted
  Future<void> updateUserRecipe() async {
    UserData userData = await getUser(uid).map(userDataFromSnapshot).first;
    return await userCollection.doc(uid).update({
      'recipeNumber': userData.recipeNumber + 1,
    });
  }

  // Update a user rating and reviewNumber when a new review is inserted
  Future<void> updateUserRating(String userId, int userRating) async {
    UserData userData = await getUser(userId).map(userDataFromSnapshot).first;
    double newRating = (userData.rating * userData.reviewNumber + userRating) /
        (userData.reviewNumber + 1);
    return await userCollection.doc(userId).update({
      'rating': newRating,
      'reviewNumber': FieldValue.increment(1),
    });
  }

  //get recipe stream
  Stream<QuerySnapshot> get recipes {
    return recipeCollection.snapshots();
  }

  //get recipe data from snapshot
  RecipeData recipeDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    return RecipeData(
      recipeId: documentSnapshot.id,
      authorId: documentSnapshot.data()['author'],
      title: documentSnapshot.data()['title'],
      subtitle: documentSnapshot.data()['subtitle'],
      description: documentSnapshot.data()['description'],
      imageURL: documentSnapshot.data()['imageURL'],
      rating: documentSnapshot.data()['rating'].toDouble(),
      time: documentSnapshot.data()['time'],
      servings: documentSnapshot.data()['servings'],
      submissionTime: documentSnapshot.data()['submissionTime'].toDate(),
      difficulty: documentSnapshot.data()['difficulty'],
      category: documentSnapshot.data()['category'],
      isVegan: documentSnapshot.data()['isVegan'],
      isVegetarian: documentSnapshot.data()['isVegetarian'],
      isGlutenFree: documentSnapshot.data()['isGlutenFree'],
      isLactoseFree: documentSnapshot.data()['isLactoseFree'],
      reviewNumber: documentSnapshot.data()['reviewNumber'],
    );
  }

  // Add a recipe document to Cloud Firestore
  Future<String> addRecipe(RecipeData recipeData) async {
    DocumentReference docRef = await recipeCollection.add({
      'author': recipeData.authorId,
      'title': recipeData.title,
      'subtitle': recipeData.subtitle,
      'description': recipeData.description,
      'imageURL': recipeData.imageURL,
      'rating': recipeData.rating,
      'time': recipeData.time,
      'servings': recipeData.servings,
      'submissionTime': Timestamp.fromDate(recipeData.submissionTime),
      'difficulty': recipeData.difficulty,
      'category': recipeData.category,
      'isVegan': recipeData.isVegan,
      'isVegetarian': recipeData.isVegetarian,
      'isGlutenFree': recipeData.isGlutenFree,
      'isLactoseFree': recipeData.isLactoseFree,
      'reviewNumber': recipeData.reviewNumber,
    });
    return docRef.id;
  }

  //get query of last num recipes
  Query getLastRecipes(int num) {
    return recipeCollection
        .orderBy('submissionTime', descending: true)
        .limit(num);
  }

  //get query of last num recipes after submissionTime
  Query getNextLastRecipes(int num, DateTime submissionTime) {
    return recipeCollection
        .orderBy('submissionTime', descending: true)
        .where('submissionTime', isLessThan: Timestamp.fromDate(submissionTime))
        .limit(num);
  }

  Future<void> updateRecipeRating(RecipeData recipeData, int userRating) async {
    double newRating =
        (recipeData.rating * recipeData.reviewNumber + userRating) /
            (recipeData.reviewNumber + 1);
    return await recipeCollection.doc(recipeData.recipeId).update({
      'rating': newRating,
      'reviewNumber': FieldValue.increment(1),
    });
  }

  //get ingredients stream from a recipe id
  Stream<QuerySnapshot> getRecipeIngredients(String recipeId) {
    return recipeCollection.doc(recipeId).collection('ingredient').snapshots();
  }

  //get ingredients data from snapshot
  IngredientData ingredientsDataFromSnapshot(
      DocumentSnapshot documentSnapshot) {
    return IngredientData(
      id: int.parse(documentSnapshot.id),
      quantity: documentSnapshot.data()['quantity'].toDouble(),
      unit: documentSnapshot.data()['unit'],
      name: documentSnapshot.data()['name'],
    );
  }

  // Add a ingredient document, under a recipe, to Cloud Firestore
  Future<void> addIngredient(
      IngredientData ingredientData, String recipeId) async {
    recipeCollection
        .doc(recipeId)
        .collection('ingredient')
        .doc(ingredientData.id.toString())
        .set({
      'quantity': ingredientData.quantity,
      'unit': ingredientData.unit,
      'name': ingredientData.name,
    });
  }

  //get steps stream from a recipe id
  Stream<QuerySnapshot> getRecipeSteps(String recipeId) {
    return recipeCollection.doc(recipeId).collection('step').snapshots();
  }

  //get steps data from snapshot
  StepData stepsDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    return StepData(
      id: int.parse(documentSnapshot.id),
      title: documentSnapshot.data()['title'],
      description: documentSnapshot.data()['description'],
      imageURL: documentSnapshot.data()['imageURL'],
    );
  }

  // Add a step document, under a recipe, to Cloud Firestore
  Future<void> addStep(StepData stepData, String recipeId) async {
    recipeCollection
        .doc(recipeId)
        .collection('step')
        .doc(stepData.id.toString())
        .set({
      'title': stepData.title,
      'description': stepData.description,
      'imageURL': stepData.imageURL,
    });
  }

  //get stream of last num recipes
  Stream<QuerySnapshot> get getUserRecipes {
    return recipeCollection
        .where('author', isEqualTo: uid)
        .orderBy('submissionTime', descending: true)
        .snapshots();
  }

  //get review stream from a recipe id
  Stream<QuerySnapshot> getReviews(String recipeId) {
    return recipeCollection.doc(recipeId).collection('review').snapshots();
  }

  //get steps data from snapshot
  ReviewData reviewDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    return ReviewData(
      reviewId: documentSnapshot.id,
      authorId: documentSnapshot.data()['author'],
      comment: documentSnapshot.data()['comment'],
      rating: documentSnapshot.data()['rating'],
      submissionTime: documentSnapshot.data()['submissionTime'].toDate(),
    );
  }

  // Add a review document, under a recipe, to Cloud Firestore
  Future<void> addReview(ReviewData reviewData, String recipeId) async {
    recipeCollection.doc(recipeId).collection('review').add({
      'author': reviewData.authorId,
      'comment': reviewData.comment,
      'rating': reviewData.rating,
      'submissionTime': Timestamp.fromDate(reviewData.submissionTime),
    });
  }

  //get query of last num reviews
  Query getLastReviews(String recipeId, int num) {
    return recipeCollection
        .doc(recipeId)
        .collection('review')
        .orderBy('submissionTime', descending: true)
        .limit(num);
  }

  //get query of last num reviews after submissionTime
  Query getNextLastReviews(String recipeId, int num, DateTime submissionTime) {
    return recipeCollection
        .doc(recipeId)
        .collection('review')
        .orderBy('submissionTime', descending: true)
        .where('submissionTime', isLessThan: Timestamp.fromDate(submissionTime))
        .limit(num);
  }

  //get the review of a certain user for a certain recipe (max 1 result)
  Stream<QuerySnapshot> getReviewByAuthor(String recipeId, String authorId) {
    return recipeCollection
        .doc(recipeId)
        .collection('review')
        .where('author', isEqualTo: authorId)
        .limit(1)
        .snapshots();
  }

  Query getFilteredRecipe(String order, String course, bool isVegan,
      bool isVegetarian, bool isGlutenFree, bool isLactoseFree) {
    Query query = recipeCollection;
    if (order == "submissionTime")
      query =
          query.where('submissionTime', isLessThanOrEqualTo: Timestamp.now());
    if (order == "rating") {
      query = query.where('rating', isLessThanOrEqualTo: 5);
    }
    if (course != "Any") query = query.where('category', isEqualTo: course);
    if (isVegan) query = query.where('isVegan', isEqualTo: true);
    if (isVegetarian) query = query.where('isVegetarian', isEqualTo: true);
    if (isGlutenFree) query = query.where('isGlutenFree', isEqualTo: true);
    if (isLactoseFree) query = query.where('isLactoseFree', isEqualTo: true);
    if (order == "rating") {
      return query
          .orderBy('rating', descending: true)
          .orderBy('submissionTime', descending: true)
          .limit(10);
    }
    return query.orderBy(order, descending: true).limit(10);
  }

  //get query of last num recipes after submissionTime
  Query getNextFilteredRecipes(
      String order,
      String course,
      bool isVegan,
      bool isVegetarian,
      bool isGlutenFree,
      bool isLactoseFree,
      DateTime submissionTime,
      double rating) {
    Query query = recipeCollection;
    if (order == "submissionTime")
      query = query.where('submissionTime',
          isLessThan: Timestamp.fromDate(submissionTime));
    if (order == "rating") {
      //query = query.where('rating', isLessThanOrEqualTo: rating);
      query = query.where('submissionTime',
          isLessThan: Timestamp.fromDate(submissionTime));
    }
    if (course != "Any") query = query.where('category', isEqualTo: course);
    if (isVegan) query = query.where('isVegan', isEqualTo: true);
    if (isVegetarian) query = query.where('isVegetarian', isEqualTo: true);
    if (isGlutenFree) query = query.where('isGlutenFree', isEqualTo: true);
    if (isLactoseFree) query = query.where('isLactoseFree', isEqualTo: true);
    if (order == "rating") {
      return query
          .orderBy('rating', descending: true)
          .orderBy('submissionTime', descending: true)
          .limit(10);
    }
    return query.orderBy(order, descending: true).limit(10);
  }
}
