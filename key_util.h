#ifndef KEYUTIL_H
#define KEYUTIL_H
/* Copyright 2015 Carlos Tse <copperoxide@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include <QtCore>
#include "util.h"

namespace ct
{
typedef struct {
    char type;
    std::string identity;
} KeyResult;

class KeyUtil
{
private:
    byte *_key, *_iv;
    bool isKeyExists(const char *);
    void generate();
    void setKey(byte *);
    void setIv(byte *);
    bool encrypt(FILE *in, FILE *out, const byte *key, const byte *iv, const byte mode);
public:
    static const int KEY_LENGTH = 32;
    static const int IV_LENGTH = 16;
    KeyUtil();
    ~KeyUtil();
    void prepareKeyIv(KeyResult *, const char *);
    static bool isEncFile(const QString);
    static bool isEncFile(const std::string);
    QString encrypt(const QString fileName, QString &errMsg);
    QString decrypt(const QString fileName, QString &errMsg);
    byte *key();
    byte *iv();
};
}

#endif // KEYUTIL_H
