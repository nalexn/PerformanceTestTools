//
//  Constants.h
//  CallbackTechniques
//
//  Created by Alexey Naumov on 30/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

#define thousand_times     1000l
#define million_times      1000000l

static inline void _repeat(long iterations, void(^block)()) {
  for (long i = 0; i < iterations; ++i) {
    block();
  }
}
