import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sewamitraapp/config/services/remote_services/api_endpoints.dart';
import 'package:sewamitraapp/feature/booking/book_now_page.dart';
import 'package:sewamitraapp/feature/home/model/provider_model.dart';
import '../model/service.dart';

class ServiceDetailsSheet extends StatelessWidget {
  final ProviderModel service;

  const ServiceDetailsSheet({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 4,
            width: 32, // Smaller handle
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64, // Smaller icon container
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // child: Icon(
                        //   service.image,
                        //   color: Colors.blue[600],
                        //   size: 32, // Smaller icon
                        // ),
                      ),
                      const SizedBox(width: 12), // Reduced spacing
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.firstname,
                              style: const TextStyle(
                                fontSize: 20, // Smaller font
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              service.serviceType,
                             // service..serviceType,
                              style: TextStyle(
                                fontSize: 14, // Smaller font
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber[600],
                                  size: 16, // Smaller icon
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${service.rating} (125 reviews)',
                                  style: TextStyle(
                                    fontSize: 12, // Smaller font
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Reduced spacing
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16, // Smaller font
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                service.serviceType=='Painter'?'Expert painting service':'Expert plumbing services for all your needs',
               
               //     '${service.description}. We provide high-quality service with experienced professionals. Our team is available 24/7 to handle all your needs with care and precision.',
                    style: TextStyle(
                      fontSize: 14, // Smaller font
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12), // Reduced padding
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Starting Price',
                              style: TextStyle(
                                fontSize: 12, // Smaller font
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Rs ${service.price.toString()} /hr',
                              style: TextStyle(
                                fontSize: 18, // Smaller font
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[600],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Reduced padding
                          decoration: BoxDecoration(
                            color: 
                            
                            //service.isAvailable
                            true
                             ? Colors.green[50] : Colors.red[50],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            //service.isAvailable ? 
                            true?
                            'Available Now' : 'Currently Busy',
                            style: TextStyle(
                              color:
                              true
                              // service.isAvailable
                               ? Colors.green[700] : Colors.red[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 12, // Smaller font
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48, // Smaller button
                    child: ElevatedButton(
                      onPressed: 
                      true
                      //service.isAvailable
                          ? () {

                        Navigator.push(context, MaterialPageRoute(builder: (builder) => BookNowPage()));
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        //service.isAvailable 
                        true
                        ? 'Book Now' : 'Currently Unavailable',
                        style: const TextStyle(
                          fontSize: 16, // Smaller font
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
