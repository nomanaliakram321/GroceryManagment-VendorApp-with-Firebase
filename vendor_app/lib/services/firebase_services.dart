import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  User user = FirebaseAuth.instance.currentUser;
  CollectionReference category =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference product =
      FirebaseFirestore.instance.collection('products');
  CollectionReference order = FirebaseFirestore.instance.collection('orders');
  CollectionReference vendorBanner =
      FirebaseFirestore.instance.collection('vendorBanner');
  CollectionReference coupan = FirebaseFirestore.instance.collection('coupans');
  CollectionReference deliveryboy =
      FirebaseFirestore.instance.collection('deliveryboys');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference vendor = FirebaseFirestore.instance.collection('vendors');
  Future<void> publishProduct({id}) {
    return product.doc(id).update({'published': true});
  }

  Future<void> unpublishProduct({id}) {
    return product.doc(id).update({'published': false});
  }

  Future<void> deleteProduct({id}) {
    return product.doc(id).delete();
  }

  Future<void> inActiveCoupan({title}) {
    return coupan.doc(title).update({'active': false});
  }

  Future<void> addBannerToFirebase(url) {
    return vendorBanner.add({'imageUrl': url, 'sellerId': user.uid});
  }

  Future<void> deleteBannerToFirebase({id}) {
    return vendorBanner.doc(id).delete();
  }

  Future<void> deletecoupanToFirebase({title}) {
    return coupan.doc(title).delete();
  }

  Future<void> saveCoupan(
      {document, title, discountRate, details, active, expiredate}) {
    if (document == null) {
      return coupan.doc(title).set({
        'title': title,
        'discountRate': discountRate,
        'details': details,
        'active': active,
        'expiredate': expiredate,
        'sellerId': user.uid
      });
    }
    return coupan.doc(title).update({
      'title': title,
      'discountRate': discountRate,
      'details': details,
      'active': active,
      'expiredate': expiredate,
      'sellerId': user.uid
    });
  }

  Future<DocumentSnapshot> getshopDetails() async {
    DocumentSnapshot snapshot = await vendor.doc(user.uid).get();
    return snapshot;
  }

  Future<DocumentSnapshot> getCustomerDetails(id) async {
    DocumentSnapshot doc = await users.doc(id).get();
    return doc;
  }

  Future<void> selectBoy(
      {orderId, uid, location, name, image, phone, email, deliveryman}) {
    var result = order.doc(orderId).update({
      'deliveryboy': {
        'location': location,
        'uid': uid,
        'name': name,
        'image': image,
        'phone': phone,
        'email': email,
      }
    }).whenComplete(() {
      deliveryboy.doc(deliveryman).update({
        'isFree': false,
      });
    });

    return result;
  }
}
