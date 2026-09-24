#ifndef COLOR_H
#define COLOR_H
#include "vec3.h"
#include <ostream>

using color = vec3;
inline void write_color(std::ostream& out, const color& pixel_color) {
  const fpm_t scale = fpm_from_ratio(255999, 1000);
  const color scaled = pixel_color * scale;
  int rbyte = fpm_to_int(scaled.x());
  int gbyte = fpm_to_int(scaled.y());
  int bbyte = fpm_to_int(scaled.z());
  out << rbyte << ' ' << gbyte << ' ' << bbyte << '\n';
}

#endif

