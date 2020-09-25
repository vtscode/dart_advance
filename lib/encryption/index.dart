import 'dart:math';
import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:pointycastle/pointycastle.dart';

/*
Encryption is meant to be secure
where encoding is meant to be a specific format.
 */
void DigestExample(){
  Digest digest = new Digest('SHA-256');
  String value = 'Halo dunia';
  Uint8List data = new Uint8List.fromList(utf8.encode(value));
  Uint8List hash = digest.process(data); // list of numbers

  print(hash);
  print(base64.encode(hash)); // ENCODING is not ENCRYPTION !!
  // encode just switch the format not hide the data
  // encryption is hiding the data
}

Uint8List createUint8ListFromString (String value) => new Uint8List.fromList(utf8.encode(value));
void display(String title, Uint8List value){
  print(title);
  print(value);
  print(base64.encode(value));
  print('');
}
void DerivingKeys(){
  String password = 'password';
  // salt key for the key
  var salt = createUint8ListFromString(password);
  var pkcs = new KeyDerivator('SHA-1/HMAC/PBKDF2');
  var params = new Pbkdf2Parameters(salt, 100, 16); // 16 its critical, more than that will be not working properly
  //initiliaze with params
  pkcs.init(params);

  Uint8List key =  pkcs.process(createUint8ListFromString(password));
  display('Key value', key);
}

//not random, but random, in cryptograpy
void SecureRandomNumber(){
  print(randomBytes(16));
}
Uint8List randomBytes (int length){
  //auto seed like salt, randomize the key
  final rnd = new SecureRandom('AES/CTR/AUTO-SEED-PRNG');
  final key = new Uint8List(16);
  final keyParams = new KeyParameter(key);
  final params = new ParametersWithIV(keyParams, new Uint8List(16));
  
  rnd.seed(params);
  
  var random = new Random();
  for(int i=0; i < random.nextInt(255);i++){
    rnd.nextUint8();
  }

  var bytes = rnd.nextBytes(length);
  return bytes;
}

void StreamChipers(){
  // use
  final keyBytes = randomBytes(16);
  final key = new KeyParameter(keyBytes);

  final iv = randomBytes(8);
  final params = new ParametersWithIV(key, iv);

  // stream
  StreamCipher cipher = new StreamCipher('Salsa20');
  cipher.init(true, params);
  //encryption
  String plainText = 'halo dunia';
  Uint8List plain_data = createUint8ListFromString(plainText);
  Uint8List encrypted_data = cipher.process(plain_data);

  // decrypt
  cipher.reset();
  cipher.init(false, params);
  Uint8List decrypt_data = cipher.process(encrypted_data);

  display('Plain text', plain_data);
  display('Encypted data text', encrypted_data);
  display('Dencypted text', decrypt_data);

//   make sure they match
  Function eq = const ListEquality().equals;
  assert(eq(plain_data,decrypt_data));

  print(utf8.decode(decrypt_data));
}

void BlockCipherExample(){
  /*
  block chiper : uses blocks of padded data to chipper, and symmetric cryptography
  * AES : Advance encryption standart
  * */
  final key = randomBytes(16); // 16 = block size
  final params = new KeyParameter(key);
  // block of data, with different modes,
  // and depending how u use mode depending on block use
  BlockCipher cipher = new BlockCipher('AES');
  cipher.init(true,params);

  //Encrypt
  String plainText = 'Halo dunia';
  Uint8List plain_data = createUint8ListFromString(plainText.padRight(cipher.blockSize));  // PAD - not 100% secure
  Uint8List encrypted_data = cipher.process(plain_data);

  // Decrypt
  cipher.reset();
  cipher.init(false, params); //we have to use same key to encrypt and decrypt
  Uint8List decrypted_data = cipher.process(encrypted_data);

  display('Plain text', plain_data);
  display('Encrypted data', encrypted_data);
  display('Dencrypted data', decrypted_data);

  // make sure they match
  Function eq = const ListEquality().equals;
  assert(eq(plain_data,decrypted_data));
  print(utf8.decode(decrypted_data).trim()); //  for trim padding on plain data
}